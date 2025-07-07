import path from 'path';
import {fileURLToPath} from 'url';
import * as typst from "typst";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);


const basePath = `${__dirname}/basic-resume`;
const inputPath = `${basePath}/resume.typ`;
const outputPath =  `${basePath}/resume.pdf`;

try {
    await typst.compile(inputPath, outputPath);
    console.log('PDF generated successfully!');
} catch (error) {
    console.error('Error generating PDF:', error);
}