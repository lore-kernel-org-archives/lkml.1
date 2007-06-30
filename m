Return-Path: <linux-kernel-owner+w=401wt.eu-S1754945AbXF3Dts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbXF3Dts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 23:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbXF3Dtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 23:49:41 -0400
Received: from mmail.enter.net ([216.193.128.40]:38319 "EHLO mmail.enter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116AbXF3Dtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 23:49:40 -0400
X-Greylist: delayed 1878 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Jun 2007 23:49:40 EDT
From: Daniel Hazelton <dhazelton@enter.net>
To: Rene Herman <rene.herman@gmail.com>
Subject: Re: Please release a stable kernel Linux 3.0
Date: Fri, 29 Jun 2007 22:11:42 -0400
User-Agent: KMail/1.9.6
Cc: 7eggert@gmx.de, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       William D Waddington <william.waddington@beezmo.com>,
       Helge Hafting <helge.hafting@aitel.hist.no>,
       linux-kernel@vger.kernel.org, Al Boldi <a1426z@gawab.com>,
       Rusty Russell <rusty@rustcorp.com.au>
References: <8AH0j-3Qc-11@gated-at.bofh.it> <E1I4Nf0-00016f-9A@be1.lrz> <46857946.20201@gmail.com>
In-Reply-To: <46857946.20201@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706292211.43170.dhazelton@enter.net>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 June 2007 17:27:34 Rene Herman wrote:
> On 06/29/2007 11:05 PM, Bodo Eggert wrote:
> > Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >> Indeed if its public domain you may have almost no rights at all
> >> depending what you were given. Once you get the source code you can do
> >> stuff but I don't have to give you that. If its public domain I can find
> >> security holes in it, and refuse to provide the fixed module in source
> >> form even.
> >
> > The GPL forces nobody to not release his module under PD, therefore it
> > can't protect you from that. Even minor changes - like adjusting the
> > module to use to the current API - won't change that, at least in Germany
> > they'd have to qualify as a work of their own in order to create a
> > GPL-only derived work, because anything not qualifying for that could
> > also be integrated into the PD version, and both would remain identical.
>
> What I focussed on when asking were only my wishes as an author but Alan
> (if I understood him right ofcourse) pointed out that _the kernel_ does not
> want integrated code to be in the public domain regardless of my wishes.
>
> Arguably (no doubt, sigh...) someone could distribute the kernel in binary
> form but refuse to provide source for the bits marked as being in the
> public domain alongside it -- yes, can of worms when compared to GPL
> demands, but I believe I can see why one shouldn't even go near there.

Actually, they couldn't. Second PD code became included in the kernel it would 
be covered by the GPL. If it can be shown that the kernel binary was the 
product of merging PD code in, then there is no way top refuse access to the 
PD code.

DRH

> Rene.
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
