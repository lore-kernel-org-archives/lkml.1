Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbYJOUE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbYJOUE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 16:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbYJOUEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 16:04:21 -0400
Received: from edna.telenet-ops.be ([195.130.132.58]:53792 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbYJOUEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 16:04:21 -0400
Date: Wed, 15 Oct 2008 22:04:17 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg KH <greg@kroah.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: is the weeks before -rc1 the time to really be working on -next?
In-Reply-To: <20081015174015.GB8663@kroah.com>
Message-ID: <Pine.LNX.4.64.0810152202230.25933@anakin>
References: <20081015174015.GB8663@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2008, Greg KH wrote:
> Just wondering, I know that -next is failing right now, and is a major
> pain to produce, but that seems to be primarily due to all of the
> subsystems merging with Linus right now.
> 
> So does it even make sense to try to create a -next during the 2 weeks
> of the major merge window?  It seems to just cause you a whole lot of
> work, that in the end, is mostly unecessary as all of the subsystem
> maintainers are doing the merging themselves as trees move into Linus's
> tree?

I don't know if it's worth the effort...

However, we definitely missed linux-next during the last few weeks, seeing
things getting into mainline that don't even survive simple compile tests.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
