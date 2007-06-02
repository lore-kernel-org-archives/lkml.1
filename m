Return-Path: <linux-kernel-owner+w=401wt.eu-S1760628AbXFBAhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760628AbXFBAhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 20:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246AbXFBAhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 20:37:40 -0400
Received: from seahorse.shentel.net ([204.111.1.244]:52247 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbXFBAhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 20:37:39 -0400
Date: Fri, 1 Jun 2007 20:37:27 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
cc: "H. Peter Anvin" <hpa@zytor.com>, Scott Preece <sepreece@gmail.com>,
       Valdis.Kletnieks@vt.edu, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/1] document Acked-by:
In-Reply-To: <m33b1b5map.fsf@maximus.localdomain>
Message-ID: <alpine.DEB.0.99.0706012032260.31394@sigma.j-a-k-j.com>
References: <200706010209.l51299kN000531@shell0.pdx.osdl.net>
 <28278.1180675923@turing-police.cc.vt.edu> <465FB862.207@zytor.com>
 <alpine.DEB.0.99.0706010648030.9768@sigma.j-a-k-j.com> <m3sl9b5vcm.fsf@maximus.localdomain>
 <7b69d1470706011237j50f29e4ch73f86acdc294fecd@mail.gmail.com>
 <m3fy5b5nrt.fsf@maximus.localdomain> <46609AEC.4070603@zytor.com>
 <m33b1b5map.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I think the comment had to do with the concept that ACK/NAK implies
> > authority.  If you're not the maintainer, it's rude to imply that you
> > are.  Obvious, test reports (good or bad!) are always welcome.
> 
> Well, I understand a test is a different thing, an experiment to
> see if the patch works or not, while ack/etc. is just opinion
> of someone who reads the patch without actually using it.
> 
> I think ack/etc doesn't, in any way, imply being the maintainer,
> though it imply that the "acker" has actually read the code,
> understands it, and believes it's correct (or not, and why).
> 
> If we want to differentiate between "authoritative" and
> "non-authoritative" opinions (and the name and email address
> aren't enough) then I think we need to state that explicite
> (perhaps something like "Acked-by: FIRST M. LAST <addr>, XXX
> subsystem maintainer" would suffice).

"Acked-by:" does not mean "I like this" but rather "I approve of this". 
Someone who is not a maintainer is encouraged to speak of like and 
dislike, in great detail, but has no position at all to approve or 
disapprove of it going in.

If I put "Acked-by: John..." on a patch of any kind, even trivial, it 
would look incredibly stupid, because I'm just some guy messing around 
with the kernel. A tactful response to me doing that from any actual 
kernel bigwig would be, "I appreciate your enthusiasm, but you are not 
part of the kernel patch flow." Similarly, a tactful response to me 
NACKing a patch would be, "I appreciate your concern, but you are in no 
position to remove a patch from the stream. Your comments will be 
considered and implemented or countered by an actual maintainer."

This is appropriate.
