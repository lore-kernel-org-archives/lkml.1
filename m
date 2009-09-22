Return-Path: <linux-kernel-owner+w=401wt.eu-S1751728AbZIVUD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbZIVUD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 16:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbZIVUD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 16:03:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750707AbZIVUDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 16:03:55 -0400
Date: Tue, 22 Sep 2009 13:03:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: tomi.valkeinen@nokia.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       tony@atomide.com, linux-omap@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [GIT PULL]: OMAP2/3 Display Subsystem
Message-Id: <20090922130304.ffe24448.akpm@linux-foundation.org>
In-Reply-To: <1253622588.25232.11.camel@tubuntu>
References: <1253622588.25232.11.camel@tubuntu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009 15:29:48 +0300
Tomi Valkeinen <tomi.valkeinen@nokia.com> wrote:

> Linus,
> 
> Here's the new display subsystem and framebuffer driver for OMAP2/3.
> 
> The driver has been reviewed on linux-omap and linux-fbdev-devel, and is in
> use, for example, on N900, Beagle Board and Overo boards. We have an ACK for
> the OMAP parts from Tony Lindgren, who maintains the OMAP platform.
> 
> We have gotten positive feedback about the driver, for example in this thread:
> http://marc.info/?l=linux-kernel&m=125171081901820&w=2
> 
> The driver is actively maintained and developed further, and I have already a
> bunch of patches on top of these patches, but I would like to get the big core
> driver merged first. After the driver is merged, other people can send patches
> to LCD drivers and board files to enable the new display subsystem on their
> boards.
> 
> Andrew said 2-3 weeks ago that he'll merge the driver (after he has looked
> through it), but he hasn't responded since then. I'm guessing he's quite busy.

That's because it came very late and conflicts considerably with
changes which are already pending.

> Please pull the new OMAP2/3 display subsystem driver from:
> 
>   git://gitorious.org/linux-omap-dss2/linux.git for-linus
> 

Confused.  These conflicts heavily with the changes which I've already
queued, does it not?  Ones which were queued way earlier than this
material.

If so, why on earth did you send a pull request, knowing that it would
trash my tree?

