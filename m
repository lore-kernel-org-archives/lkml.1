Return-Path: <linux-kernel-owner+w=401wt.eu-S1754011AbXEAPBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbXEAPBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 11:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbXEAPBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 11:01:50 -0400
Received: from tim.rpsys.net ([194.106.48.114]:45225 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011AbXEAPBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 11:01:48 -0400
Subject: Re: [RFC, PATCH 0/4] SoC base drivers
From: Richard Purdie <rpurdie@rpsys.net>
To: Paul Sokolovsky <pmiscml@gmail.com>
Cc: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>,
       kernel-discuss@handhelds.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <1068016897.20070501173657@gmail.com>
References: <1354376306.20070501080806@gmail.com>
	 <46374645.2030900@gmail.com>  <1068016897.20070501173657@gmail.com>
Content-Type: text/plain
Date: Tue, 01 May 2007 16:01:15 +0100
Message-Id: <1178031675.5883.67.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-01 at 17:36 +0300, Paul Sokolovsky wrote:
>         Either way, I don't pledge to be a HW designer with
> contemporary lexicon. The aim was simple - as a single word would be
> too ambiguous, general, or vice-versa, omitting, then acronym is
> needed, hopefully existing, and not new, and SoC is the most fitting
> TLA, IMHO. But I'm open to specific suggestions for improvement. For
> example, if I was to write a Documentation/ entry for that, I'd mention
> companion chips, peripheral/integrated controllers, etc. But renaming
> drivers/soc/ to drivers/companion/ would be more confusing, as the
> concept described is not tied to companion chips per se (even though
> many of chips we (handhelds.org) deal with, can be classified as
> such).

A while back I proposed drivers/mfd/ (multi function devices) and there
are a couple of drivers in there in mainline which probably fit your
description of SoC. The code I had once intended for there is probably
more ASoC related now...

Richard





