Return-Path: <linux-kernel-owner+w=401wt.eu-S932943AbXDZGaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943AbXDZGaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932985AbXDZGaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:30:18 -0400
Received: from outmx013.isp.belgacom.be ([195.238.5.64]:58686 "EHLO
	outmx013.isp.belgacom.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932943AbXDZGaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:30:16 -0400
From: Jan De Luyck <ml_linuxkernel_20060528@kcore.org>
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.21
Date: Thu, 26 Apr 2007 08:30:01 +0200
User-Agent: KMail/1.9.6
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704260830.01336.ml_linuxkernel_20060528@kcore.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 April 2007, Linus Torvalds wrote:
> If the goal for 2.6.20 was to be a stable release (and it was), the goal
> for 2.6.21 is to have just survived the big timer-related changes and some
> of the other surprises (just as an example: we were apparently unlucky
> enough to hit what looks like a previously unknown hardware errata in one
> of the ethernet drivers that got updated etc).
>
> So it's been over two and a half months, and while it's certainly not the
> longest release cycle ever, it still dragged out a bit longer than I'd
> have hoped for and it should have. As usual, I'd like to thank Adrian (and
> the people who jumped on the entries Adrian had) for keeping everybody on
> their toes with the regression list - there's a few entries there still,
> but it got to the point where we didn't even know if they were real
> regressions, and delaying things further just wasn't going to help.

I've just compiled 2.6.21, seems to run fine, in tickless mode, on a Dell 
D610.

Is there any way to check how many timer ticks are firing, except for 
monitoring /proc/interrupts?

Thanks for all the hard work!

Jan

-- 
She has an alarm clock and a phone that don't ring -- they applaud.
