import SwiftUI

struct SectionHeaderView: View {
    @Binding var isExpanded: Bool
    let text: LocalizedStringKey

    var body: some View {
        HStack {
            Text(text)
                .textStyle(with: .Td.gray, size: 20, weight: .medium)
            Spacer()
            (isExpanded ? AppSymbol.chevronDown : AppSymbol.chevronRight)
                .imageView(.Td.gray)
                .frame(maxWidth: 20, maxHeight: 20)
        }
        .onTapGesture {
            isExpanded.toggle()
        }
    }
}

#Preview {
    VStack {
        SectionHeaderView(isExpanded: .constant(true), text: .init("isExpanded: true"))
            .devStroke()
        SectionHeaderView(isExpanded: .constant(false), text: .init("isExpanded: false"))
            .devStroke()
    }
    .padding()
}
