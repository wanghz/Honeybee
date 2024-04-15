import sys
import urllib.parse

def url_encode_file(input_file, output_file):
    try:
        with open(input_file, 'r', encoding='utf-8') as infile:
            content = infile.read()
            encoded_content = urllib.parse.quote(content, safe='')
            with open(output_file, 'w', encoding='utf-8') as outfile:
                outfile.write(encoded_content)
            print(f"Encoded content saved to {output_file}.")
    except FileNotFoundError:
        print("Input file not found.")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python url_encode_file.py <input_file> <output_file>")
    else:
        input_file = sys.argv[1]
        output_file = sys.argv[2]
        url_encode_file(input_file, output_file)
