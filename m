Return-Path: <linux-kernel-owner+w=401wt.eu-S1762110AbYDSPmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762110AbYDSPmf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 11:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbYDSPmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 11:42:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:58141 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761635AbYDSPmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 11:42:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=opj6GLeAU9CRifSZ5uxK7n2u/9GCZ2YvxATxwtHSYU+3FobwWSyM61pwEAYKvyeSBdkkN5OWoHJQX0QHQOBWYwAJYpl0pwZNe+2xJeGQMmGNj2E9a6aQy1Hh89R4AnvMirqZu5mgiW0GMNrzv4+MnuiK0VlY/wL1JpJ0Ezgbckw=
Message-ID: <6101e8c40804190842n315bd61ft5ae0cffd456a8519@mail.gmail.com>
Date: Sat, 19 Apr 2008 17:42:05 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: x86: 4kstacks default
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Christoph Hellwig" <hch@infradead.org>, "David Chinner" <dgc@sgi.com>,
       xfs@oss.sgi.com
In-Reply-To: <20080419151911.GB1595@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804181737.m3IHbabI010051@hera.kernel.org>
	 <20080418142934.38ce6bf4.akpm@linux-foundation.org>
	 <20080419142329.GA5339@elte.hu>
	 <6101e8c40804190735g17f1e0bj25c2bc0e2a6eac26@mail.gmail.com>
	 <20080419151911.GB1595@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I dont know, thet this problem presentiert in 2.6.25, but im older
kernels yes (2.6.22> or 2.6.23>).

On 4/19/08, Adrian Bunk <bunk@kernel.org> wrote:
> On Sat, Apr 19, 2008 at 04:35:31PM +0200, Oliver Pinter wrote:
> >...
> > with the older kernel is typical: xfs+nfs+4k stack(+lvm)
>
> Does anyone still experience problems with 2.6.25?
>
> We all know that there once were problems, but if there are any left
> they should be reported and fixed.
>
> > Thanks,
> > Oliver
>
> cu
> Adrian
>
> --
>
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
>
>


-- 
Thanks,
Oliver
