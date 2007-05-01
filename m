Return-Path: <linux-kernel-owner+w=401wt.eu-S1161766AbXEAS62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161766AbXEAS62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 14:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161772AbXEAS62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 14:58:28 -0400
Received: from tim.rpsys.net ([194.106.48.114]:49510 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161769AbXEAS61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 14:58:27 -0400
Subject: Re: [RFC, PATCH 0/4] SoC base drivers
From: Richard Purdie <rpurdie@rpsys.net>
To: Paul Sokolovsky <pmiscml@gmail.com>
Cc: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>,
       kernel-discuss@handhelds.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <97946200.20070501201821@gmail.com>
References: <1354376306.20070501080806@gmail.com>
	 <46374645.2030900@gmail.com>  <1068016897.20070501173657@gmail.com>
	 <1178031675.5883.67.camel@localhost.localdomain>
	 <97946200.20070501201821@gmail.com>
Content-Type: text/plain
Date: Tue, 01 May 2007 19:58:11 +0100
Message-Id: <1178045891.5883.78.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-01 at 20:18 +0300, Paul Sokolovsky wrote:
> Tuesday, May 1, 2007, 6:01:15 PM, you wrote:
> > A while back I proposed drivers/mfd/ (multi function devices) and there
> > are a couple of drivers in there in mainline which probably fit your
> > description of SoC. The code I had once intended for there is probably
> > more ASoC related now...
> 
>         Well, while description catches the essence of course, TLA is
> far from being perfect: 1) Completely unknown; 2) can be easily
> confused with mtd.
> 
>         But it's even more funny: there *is* drivers/mfd/ already in
> mainline. I'd say that we were blind, but even you say "proposed", not
> "exists", nor anybody else brought that to attention. I'm afraid, that
> proves point 1 above ;-).

"there are a couple of drivers in there in mainline" implies I knew of
its existence ;-).

As for your second point, most users will just see "Multi Function" or
"Memory Technology" which should be different enough.

Cheers,

Richard

