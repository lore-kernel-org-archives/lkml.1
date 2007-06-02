Return-Path: <linux-kernel-owner+w=401wt.eu-S1762067AbXFBA4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762067AbXFBA4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 20:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757622AbXFBA4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 20:56:34 -0400
Received: from khc.piap.pl ([195.187.100.11]:59529 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755508AbXFBA4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 20:56:33 -0400
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Scott Preece <sepreece@gmail.com>,
       Valdis.Kletnieks@vt.edu, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/1] document Acked-by:
References: <200706010209.l51299kN000531@shell0.pdx.osdl.net>
	<28278.1180675923@turing-police.cc.vt.edu> <465FB862.207@zytor.com>
	<alpine.DEB.0.99.0706010648030.9768@sigma.j-a-k-j.com>
	<m3sl9b5vcm.fsf@maximus.localdomain>
	<7b69d1470706011237j50f29e4ch73f86acdc294fecd@mail.gmail.com>
	<m3fy5b5nrt.fsf@maximus.localdomain> <46609AEC.4070603@zytor.com>
	<m33b1b5map.fsf@maximus.localdomain>
	<alpine.DEB.0.99.0706012032260.31394@sigma.j-a-k-j.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 02 Jun 2007 02:56:30 +0200
In-Reply-To: <alpine.DEB.0.99.0706012032260.31394@sigma.j-a-k-j.com> (John Anthony Kazos, Jr.'s message of "Fri, 1 Jun 2007 20:37:27 -0400 (EDT)")
Message-ID: <m3lkf341j5.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"John Anthony Kazos Jr." <jakj@j-a-k-j.com> writes:

> "Acked-by:" does not mean "I like this" but rather "I approve of this".

I'd say it means "I acknowledge it". If you want to express
approval, why not use some sort of "Approved-by"?

> If I put "Acked-by: John..." on a patch of any kind, even trivial, it 
> would look incredibly stupid, because I'm just some guy messing around 
> with the kernel. A tactful response to me doing that from any actual 
> kernel bigwig would be, "I appreciate your enthusiasm, but you are not 
> part of the kernel patch flow." Similarly, a tactful response to me 
> NACKing a patch would be, "I appreciate your concern, but you are in no 
> position to remove a patch from the stream. Your comments will be 
> considered and implemented or countered by an actual maintainer."
>
> This is appropriate.

You seem to know these things very well.
-- 
Krzysztof Halasa
