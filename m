Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbXJWRf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbXJWRf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 13:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbXJWRfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 13:35:13 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:6536 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbXJWRfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 13:35:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=L7ltseU4vfoC9VD27+9HKtY2WAzgBobflewP3G34ndjOkjMU91E4TX7472gC3kRPiMPGiYc3QueTcy3BXBK6xRHS4oQBM+MmlAcoEr4ziTqlL+HbValYy1afewBzMyp6hGgXunc+a/oVJ/wD0NS/PyiQ3zckn3pKbf2U/UgPRQk=
Message-ID: <8bd0f97a0710231035nafbd7f1q3a1f2b6907d7350f@mail.gmail.com>
Date: Tue, 23 Oct 2007 13:35:10 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Kirill A. Shutemov" <k.shutemov@velesys.com>
Subject: Re: [PATCH] Do not export PAGE_SIZE to userspace.
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071023165951.GA5685@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071023103304.GA10209@localhost.localdomain>
	 <8bd0f97a0710230922t57699cc3o7f1eda45c488a053@mail.gmail.com>
	 <20071023165951.GA5685@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/07, Kirill A. Shutemov <k.shutemov@velesys.com> wrote:
> On [Tue, 23.10.2007 12:22], Mike Frysinger wrote:
> > On 10/23/07, Kirill A. Shutemov <k.shutemov@velesys.com> wrote:
> > > Userspace should use getpagesize() or sysconf(_SC_PAGESIZE) to get memory
> > > page size.
> >
> > please go back through the archives and read the history here.  we
> > should work at dropping page.h completely, not making it an empty
> > file.
>
> Do you mean page.h shouldn't be exported to userspace

yes

> or should be dropped from kernelspace too?

noooooooooooooooooo

;)
-mike
