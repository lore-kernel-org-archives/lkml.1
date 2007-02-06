Return-Path: <linux-kernel-owner+w=401wt.eu-S1751879AbXBFM4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbXBFM4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 07:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbXBFM4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 07:56:44 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:9754 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbXBFM4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 07:56:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qaPIA3elHiKKQy4okcyXX+ykC+V6hErXlfosdO9JUDgHTe4Ahp/t+4BcSend11I1EHZZ2iKcTxQZPd3UZ7WapiBFhny0hXXo0jk098A1PRfeHly4Z8cj/kZ3Zm0YjD6q5KZDq3/Izm630bPJRwqBvt2lBzCSQQZVfv571aJU6mw=
Message-ID: <1a297b360702060456t381b2b2fobfaebac95e1e0ccd@mail.gmail.com>
Date: Tue, 6 Feb 2007 16:56:40 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Luming Yu" <luming.yu@gmail.com>
Subject: Re: 2.6.20 PCI Cannot allocate resource region 2
Cc: "Grant Grundler" <grundler@parisc-linux.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       greg@kroah.com
In-Reply-To: <1a297b360702060456n654c976fycb8fcb37012c6212@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1a297b360702041709l3b0309c7y8fcd33df1d487889@mail.gmail.com>
	 <20070206045528.GA4228@colo.lackof.org>
	 <20070206050331.GB4228@colo.lackof.org>
	 <20070205213339.80239a22.akpm@linux-foundation.org>
	 <20070206084638.GB20752@colo.lackof.org>
	 <1a297b360702060106x321bfb8dw918d15df76952576@mail.gmail.com>
	 <1a297b360702060129n54f73e66qc753a2ccb35cb3cd@mail.gmail.com>
	 <3877989d0702060421g1a00c114yba9e193db55f3d11@mail.gmail.com>
	 <1a297b360702060424m393d66cdka4a446b24cbd1ff@mail.gmail.com>
	 <1a297b360702060456n654c976fycb8fcb37012c6212@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/6/07, Manu Abraham <abraham.manu@gmail.com> wrote:
> On 2/6/07, Manu Abraham <abraham.manu@gmail.com> wrote:
> > On 2/6/07, Luming Yu <luming.yu@gmail.com> wrote:
> > > > dang !
> > > >
> > > > rebooted it into 2.6.17.7
> > > >
> > > > no errors, during a bootup, BIST isn't running anymore
> > > > running M$ did change the status from dead to alive ??? shocked !!
> > >
> > > Interesting!  does windows driver fixes the broken firmware/flash on this card?
> >
> >
> > No firmware/flash on the card.
> >
> >
> > >
> > > >
> > > > attached lspci output in the very same setup as earlier, no difference
> > > > in anything, except that it was rebooted into windows.
> > > >
> > > > the PCI config dump would help ?
> > > >
> > >
> > > I guess you would never reproduce this issue again unless you can
> > > restore the broken firmware/flash on this card. :-)
> > >
> >
> > none on the card, a flash or a firmware .. it has a 24c02 EEPROM for
> > vendor information, that's all
> >
>
> You can see the same from this picture

http://abraham.manu.googlepages.com/p3130016.jpg


>
> regards,
> manu
>
