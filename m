Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbXEAT2C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbXEAT2C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 15:28:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755301AbXEAT2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 15:28:01 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3487 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630AbXEAT2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 15:28:00 -0400
Date: Tue, 1 May 2007 20:27:48 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Paul Sokolovsky <pmiscml@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>,
       Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>,
       kernel-discuss@handhelds.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [RFC, PATCH 0/4] SoC base drivers
Message-ID: <20070501192747.GE19872@flint.arm.linux.org.uk>
Mail-Followup-To: Paul Sokolovsky <pmiscml@gmail.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>,
	kernel-discuss@handhelds.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk
References: <1354376306.20070501080806@gmail.com> <46374645.2030900@gmail.com> <1068016897.20070501173657@gmail.com> <1178031675.5883.67.camel@localhost.localdomain> <97946200.20070501201821@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97946200.20070501201821@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 08:18:21PM +0300, Paul Sokolovsky wrote:
>         Well, while description catches the essence of course, TLA is
> far from being perfect: 1) Completely unknown; 2) can be easily
> confused with mtd.
> 
>         But it's even more funny: there *is* drivers/mfd/ already in
> mainline. I'd say that we were blind, but even you say "proposed", not
> "exists", nor anybody else brought that to attention. I'm afraid, that
> proves point 1 above ;-).

It's only unknown to communities which do not read this mailing list.

drivers/mfd was suggested after discussion here about where to put the
UCB1[23]00 device drivers, since it was felt that drivers/misc was
inappropriate.

There's not much infrastructure there though.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
