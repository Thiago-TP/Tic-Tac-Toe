import sys
from numpy import asarray
from PIL import Image


def img2data(image_file_name):
    image = Image.open(image_file_name)
    contents = asarray(image)

    if len(contents.shape) != 3:
        print('Bit intensity not equal to 24, the file could not be converted.')
        return
    if contents.shape[2] != 3:
        print('Bit intensity not equal to 24, the file could not be converted.')
        return

    image_height, image_length, _ = contents.shape  # _ hold the 'type' of the file (RGB) and won't be used

    RGBs = [RGB for line in contents for RGB in line] # noqa

    path, label = get_path_and_label(image_file_name)
    data_name = label + '.data'

    with open(path + data_name, 'w') as data_file:
        sys.stdout = data_file  # print will mark the .data file
        print(label, end=':\t')
        print('.word %d, %d\n.byte' % (image_length, image_height))

        column_cont = 0
        for RGB in RGBs:
            red_value, green_value, blue_value = RGB
            color_byte = \
                (round(7 * red_value / 255) << 0) + \
                (round(7 * green_value / 255) << 3) + \
                (round(3 * blue_value / 255) << 6)
            print(color_byte, end='')

            num_spaces = 4 - len(str(color_byte))   # variable spacing for better visualization
            print(num_spaces * ' ', end='')

            column_cont += 1
            if column_cont == image_length:
                column_cont = 0
                print()

    sys.stdout = sys.__stdout__     # print back to marking terminal
    print("%s %dx%d created in '%s'" % (data_name, image_length, image_height, path))


def get_path_and_label(image_file_name):
    backwards_name = image_file_name[::-1]
    last_dot_pos = -backwards_name.index('.')
    last_slash_pos = 0
    if '/' in image_file_name:
        last_slash_pos = -backwards_name.index('/')

    path = image_file_name[:last_slash_pos]
    label = image_file_name[last_slash_pos:last_dot_pos - 1]
    return path, label


if __name__ == '__main__':
    img2data(input())
