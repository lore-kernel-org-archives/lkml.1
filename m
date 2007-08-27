Return-Path: <linux-kernel-owner+w=401wt.eu-S965266AbXH0Vux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965266AbXH0Vux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763232AbXH0Vgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:36:39 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59311 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755703AbXH0Vgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:36:38 -0400
Date: Mon, 27 Aug 2007 23:36:37 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Olaf Hering <olh@suse.de>
Subject: Re: [-mm patch] make types.h usable for non-gcc C parsers
Message-ID: <20070827213637.GN26410@stusta.de>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <46CC3B27.10604@googlemail.com> <20070827212743.GN4121@stusta.de> <8bd0f97a0708271434y2d0dac76v6ab4036cec0aadd9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8bd0f97a0708271434y2d0dac76v6ab4036cec0aadd9@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2007 at 05:34:21PM -0400, Mike Frysinger wrote:
> On 8/27/07, Adrian Bunk <bunk@kernel.org> wrote:
> > This patch makes the 64bit integers on 32bit architectures usable for
> > all C parsers that know about "long long".
> 
> ah, yet another attempt at this stuff
> 
> you probably need to update linux/types.h as well

What problems do you observe with linux/types.h?

> -mike

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

