Return-Path: <linux-kernel-owner+w=401wt.eu-S1751783AbXBFMVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbXBFMVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 07:21:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750922AbXBFMVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 07:21:24 -0500
Received: from wr-out-0506.google.com ([64.233.184.239]:27351 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbXBFMVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 07:21:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YWmaoyUMyB6I09SaW6fXVH676RXCzhw3XWJEKHOMBBhXqTD5A6+MDGv73gX6Reb8UEPfwSHGJUjuWdBNpmPbbAuFffycmAvL0Jz/iAVQ3t0O7O03IUsoaVSh6kcVfe8CPP9+JDdBGXz0BRLoEmc5s3OShxYU/F+MX35q1bor1RI=
Message-ID: <3877989d0702060421g1a00c114yba9e193db55f3d11@mail.gmail.com>
Date: Tue, 6 Feb 2007 20:21:21 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Manu Abraham" <abraham.manu@gmail.com>
Subject: Re: 2.6.20 PCI Cannot allocate resource region 2
Cc: "Grant Grundler" <grundler@parisc-linux.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       greg@kroah.com
In-Reply-To: <1a297b360702060129n54f73e66qc753a2ccb35cb3cd@mail.gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> dang !
>
> rebooted it into 2.6.17.7
>
> no errors, during a bootup, BIST isn't running anymore
> running M$ did change the status from dead to alive ??? shocked !!

Interesting!  does windows driver fixes the broken firmware/flash on this card?

>
> attached lspci output in the very same setup as earlier, no difference
> in anything, except that it was rebooted into windows.
>
> the PCI config dump would help ?
>

I guess you would never reproduce this issue again unless you can
restore the broken firmware/flash on this card. :-)
