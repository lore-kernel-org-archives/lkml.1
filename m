Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbYJPPSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbYJPPSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 11:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbYJPPSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 11:18:14 -0400
Received: from winston.telenet-ops.be ([195.130.137.75]:50952 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbYJPPSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 11:18:14 -0400
Date: Thu, 16 Oct 2008 17:18:10 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg KH <greg@kroah.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
In-Reply-To: <20081016002509.GA25868@kroah.com>
Message-ID: <Pine.LNX.4.64.0810161715240.25933@anakin>
References: <20081016002509.GA25868@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2008, Greg KH wrote:
> You brought this topic up a few months ago, and passed it off as
> something we would discuss at the kernel summit.  But that never
> happened, so I figured I'd bring it up again here.
> 
> So, as someone who constantly is dealing with kernel version numbers all
> the time with the -stable trees, our current numbering scheme is a pain
> a times.  How about this proposal instead?

> Any thoughts?
> 
> Let the bike-shedding begin!

What about just using the git SHA1?

Advantages:
  - We're all getting older. Training our memory to remember SHA1 IDs is
    actually good for us!
  - Perhaps Google will finally start tracking git commits, so I can
    feed them a git commit ID mentioned in a random email and find the
    actual commit, without having to know to which repository it
    belongs?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
