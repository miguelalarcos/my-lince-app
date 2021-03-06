const validateItem = {
    desc: (val) => {
        if(/^\w+\s+\w+\s+\w+.*$/.test(val)){
            return ''
        }
        else{
            return 'Al menos tres palabras'
        }
    },
    done: (val) => '',
    id: (val) => '',
    validate: (doc) => {
        return validateItem.desc(doc.desc) == ''
    }
}

module.exports.validateItem = validateItem