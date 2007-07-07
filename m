Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbXGGQ7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbXGGQ7g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 12:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbXGGQ70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 12:59:26 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:16504 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbXGGQ7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 12:59:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VEX3mFhO1NCGM2IugAY5SiEtExbuBTD72A+UILIPDx16vFzO/LTNFKCJXTwMOPmywWhssOZUMtxFcADKnVdvvQlkK12vzyZq5GYZW3GYyRV+1R8fUOT72E3QD6h9rW3DokW5F23DwHvlc1pb3/LzmBhdY6wXJBodE8DWGl3FJLc=
Message-ID: <6bffcb0e0707070959m12ba9b66n8587605eb1f6c21e@mail.gmail.com>
Date: Sat, 7 Jul 2007 18:59:24 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: 2.6.22-rc7: known regressions with patches v2
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Adrian Bunk" <bunk@stusta.de>,
       "Patrick Caulfield" <pcaulfie@redhat.com>,
       "David Teigland" <teigland@redhat.com>,
       bluez-devel@lists.sourceforge.net,
       "Marcel Holtmann" <marcel@holtmann.org>,
       "Jiri Kosina" <jkosina@suse.cz>, "Dmitry Torokhov" <dtor@insightbb.com>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <1183825391.3066.59.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <468FBA20.8060509@googlemail.com>
	 <1183825391.3066.59.camel@shinybook.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/07, David Woodhouse <dwmw2@infradead.org> wrote:
> On Sat, 2007-07-07 at 18:06 +0200, Michal Piotrowski wrote:
> > FBDEV
> >
> > Subject         : SLUB kmalloc-32768: Poison check failed@0xc1e20000
> > slab 0xc04de400
> > References      : http://lkml.org/lkml/2007/7/4/305
> > Last known good : ?
> > Submitter       : David Woodhouse <dwmw2@infradead.org>
> > Caused-By       : ?
> > Handled-By      : ?
> > Status          : unknown
>
> If you're looking for someone to blame, consider the fact that this has
> gone away now I've switched back to slab. :)
>

Yup, I forgot to add Christoph to CC  :)

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
