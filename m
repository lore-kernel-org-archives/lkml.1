Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbXDOReG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbXDOReG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 13:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbXDOReG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 13:34:06 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:49419 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbXDOReF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 13:34:05 -0400
Subject: Re: ZFS with Linux: An Open Plea
From: Kasper Sandberg <lkml@metanurb.dk>
To: "David R. Litwin" <presently42@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <op.tqththp8ftfxs2@localhost.localdomain>
References: <op.tqththp8ftfxs2@localhost.localdomain>
Content-Type: text/plain; charset=windows-1251
Date: Sun, 15 Apr 2007 19:34:05 +0200
Message-Id: <1176658445.25810.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-15 at 04:57 -0400, David R. Litwin wrote:
> On 15/04/07,  Kasper Sandberg <lkml@metanurb.dk> wrote:
> On Fri, 2007-04-13 at 19:18 -0400, David R. Litwin wrote:
> 
> > By the way, forget about this FUSE business. I don't know why they're
> > bothering: It's not real, it's slow and, in general, silly.
> This seems to me to be a rather uninformed, arrogant, and quite stupid
> comment.
> 
> Thank you, sir, for calling my comment stupid. Perhaps you are one of  
> those FUSE folk. In that case, I would love for you to enlighten
> me as to why any one would bother attempting to port a file system when it  
> is known that not only is it much slower than the slowest
> currently available to Linux, but also does not provide much of the  
> functionality of the original product.
Well first off, i dont believe anyone has ever prooved that an fuse
filesystem on linux is inheritly much slower than the slowest filesystem
on linux, in fact i believe this to be very far from the truth, and even
if you are not able to squeeze the last bits of efficiency out, i doubt
that its gonna be the cpu overhead that will kill your IO performance.
ZFS-on-FUSE may not have all the features now, it may not ever get them,
but its far from pointless, but whats even more pointless and silly, is
you blindly acknowledging that you are uninformed and seeking
information (which is okay enough), but at the same time calls stuff
silly and unreal.

> 
> As to uninformed, well, yes, I am uninformed; hence my request for you to  
> inform me. And arrogant? I sure am.
> 
> Cheers.
> 
> --
> —A watched bread-crumb never boils.
> —My hover-craft is full of eels.
> —[...]and that's the he and the she of it.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

