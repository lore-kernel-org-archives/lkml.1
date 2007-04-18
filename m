Return-Path: <linux-kernel-owner+w=401wt.eu-S932753AbXDRHLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753AbXDRHLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 03:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932750AbXDRHLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 03:11:00 -0400
Received: from asia.telenet-ops.be ([195.130.137.74]:34825 "EHLO
	asia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932764AbXDRHK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 03:10:58 -0400
Date: Wed, 18 Apr 2007 09:10:57 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: drivers/video/output.c
In-Reply-To: <20070417213716.GB7284@redhat.com>
Message-ID: <Pine.LNX.4.64.0704180908450.3288@anakin>
References: <20070417213716.GB7284@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007, Dave Jones wrote:
> git-bisect just fingered it as responsible for my "backlight doesn't turn on"
> suspend/resume regression on the Thinkpad X60.  I think it's lying.

Actually I've seeing git bisect lying on me, too. I retried a few times
(fortunately it didn't require rebooting, as the problem was just a compile
error) to make sure I made no mistakes in answering, but I always ended up
with the wrong commit.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
