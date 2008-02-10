Return-Path: <linux-kernel-owner+w=401wt.eu-S1756598AbYBJUrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbYBJUrx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 15:47:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754879AbYBJUrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 15:47:46 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:21707 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbYBJUro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 15:47:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eQA/zV3RBgvJeoLVIL8Ak5FMoPgkjkEGPKeV5K9k4QgHINCBoSooBUzsXER4VR4bCv6nNgq1Bn0j6taDLiPKRL3/7IgNO/W438ri1k2S8f5c1ImpkCsAMyURF3fSs8FWsoGaWBvSauE4LSxQOuXZeZAm1z4dN/TNCXA0vczCP90=
Message-ID: <86802c440802101247j334f3fc2i74cb176e25dac3d9@mail.gmail.com>
Date: Sun, 10 Feb 2008 12:47:41 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: [PATCH] Change pci_raw_ops to pci_raw_read/write
Cc: "Greg KH" <greg@kroah.com>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Tony Camuso" <tcamuso@redhat.com>,
       "Grant Grundler" <grundler@parisc-linux.org>,
       "Loic Prylli" <loic@myri.com>, "Adrian Bunk" <bunk@kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Ivan Kokshaysky" <ink@jurassic.park.msu.ru>,
       "Greg KH" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       "Jeff Garzik" <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       "Martin Mares" <mj@ucw.cz>
In-Reply-To: <20080210203239.GF5299@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080129030340.GE20198@parisc-linux.org>
	 <47AB299D.4000500@redhat.com>
	 <20080209124138.GA28967@parisc-linux.org>
	 <86802c440802092225u5a901ab2i66b952382a999fa@mail.gmail.com>
	 <20080210072116.GA12375@kroah.com>
	 <20080210145122.GC5299@parisc-linux.org>
	 <86802c440802101216t3b04c0b4y89a05ac9a04a0ac5@mail.gmail.com>
	 <20080210201955.GE5299@parisc-linux.org>
	 <86802c440802101225k2a7a1dc9pe6d3f26af1c5b452@mail.gmail.com>
	 <20080210203239.GF5299@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 10, 2008 12:32 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Sun, Feb 10, 2008 at 12:25:02PM -0800, Yinghai Lu wrote:
> > Even Greg didn't know that there was another patch need to be applied
> > before this one yesterday.
>
> I don't believe you.  For example:
>
> On Mon, Jan 28, 2008 at 02:53:34PM -0800, Greg KH wrote:
> > Please send me patches, in a form that can be merged, along with a
> > proper changelog entry, in the order in which you wish them to be
> > applied, so I know exactly what changes you are referring to.
>
> Which I then did.

then you may need to send patches to Greg: So Grey or others don'e
need to dig Ivan's patch

[PATCH 0/2]...
[PATCH 1/2]... Ivan's patch with from statement
[PATCH 2/2] ... your patch

YH
