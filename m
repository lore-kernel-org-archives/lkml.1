Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbXDMLiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbXDMLiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 07:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbXDMLiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 07:38:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:12198 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbXDMLiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 07:38:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=C1Z+BxqEEW46jCtMBR7J87y8bY3p4TXPM6QMLYcgH+pQGx9pclKa5ShANgrc21s1n4B8Dvcd5wcRcflABniHXfMBLVC+tiHcoZlOPTYHbtkhPabxi6ynR3pmtPFXwqMw/SWr+xzpujnEOiL2KflXJCnLTbB+jCIx60m/8TQ6vGQ=
Message-ID: <a872555b0704130438p602b8acbg520871d692266309@mail.gmail.com>
Date: Fri, 13 Apr 2007 15:38:18 +0400
From: "Denis Kirjanov" <kirjanov@gmail.com>
To: "Marat Buharov" <marat.buharov@gmail.com>
Subject: Re: 2.6.20.6 vanilla does't boot
Cc: "Marc Donner" <Marc.Donner@dbd-breitband.de>, linux-kernel@vger.kernel.org
In-Reply-To: <698310e10704122335t7cc42546pe1468d4d25fdd9d4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a872555b0704122234m6f26405l293dd39f8af672b6@mail.gmail.com>
	 <C244E4A2.1CF94%Marc.Donner@dbd-breitband.de>
	 <a872555b0704122246n7be574e7mc53920d6e446f86@mail.gmail.com>
	 <698310e10704122335t7cc42546pe1468d4d25fdd9d4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I updated the BIOS to the latest version, but the problem persists.
Boots option pci = noacpi not solved the problem. Reporting bios bug
disappears when setting pci = nommconf, But the kernel is still not
loaded (
