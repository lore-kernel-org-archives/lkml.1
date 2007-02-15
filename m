Return-Path: <linux-kernel-owner+w=401wt.eu-S966103AbXBOQjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966103AbXBOQjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 11:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966102AbXBOQjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 11:39:42 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:32861 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966103AbXBOQjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 11:39:41 -0500
Message-ID: <45D48CD0.7080107@drzeus.cx>
Date: Thu, 15 Feb 2007 17:39:44 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
MIME-Version: 1.0
To: Eugene Ilkov <e.ilkov@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20 mmc: problem with highspeed SD card
References: <e13597370702131746q6a5d8e79i2341f5eb9c59bf6e@mail.gmail.com>	 <45D3F41C.3020600@drzeus.cx> <e13597370702150417o3888b71dtcc42e38156b46918@mail.gmail.com>
In-Reply-To: <e13597370702150417o3888b71dtcc42e38156b46918@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eugene Ilkov wrote:
>
> I found another related patch
> http://mailman.laptop.org/pipermail/commits-kernel/2007-January/000554.html
>
> so i guess i'm not alone
>

You'd better pray that's not the problem you have because that revert
was because the hardware under development had problems.

>
> mmc debug output is too noisy
> and i can give you only this:
>

That dump doesn't cover the problem, so I can't draw any conclusions
from it.

> i boot into root fs on SD, and it just hangs on remounting to rw, so
> it's not easy to get full dmesg output with i/o error and mmc debug
> info, but i'll try if it helps

I'm afraid I can't help you without a dmesg dump. This problem is most
likely crappy hardware at some point, and I need details to make any
guess about what it doesn't like.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

