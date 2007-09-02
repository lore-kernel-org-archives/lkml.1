Return-Path: <linux-kernel-owner+w=401wt.eu-S933155AbXIBPLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933155AbXIBPLT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 11:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbXIBPLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 11:11:08 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:33721 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbXIBPLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 11:11:07 -0400
Subject: Re: [ANNOUNCE/RFC] Really Fair Scheduler
From: Daniel Walker <dwalker@mvista.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org
In-Reply-To: <Pine.LNX.4.64.0709021634370.1817@scrub.home>
References: <Pine.LNX.4.64.0708310139280.1817@scrub.home>
	 <1188694367.11196.42.camel@dhcp193.mvista.com>
	 <Pine.LNX.4.64.0709021634370.1817@scrub.home>
Content-Type: text/plain
Date: Sun, 02 Sep 2007 08:00:08 -0700
Message-Id: <1188745208.11196.59.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-09-02 at 16:47 +0200, Roman Zippel wrote:

> > > (1)	time = sum_{t}^{T}(time_{t})
> > > (2)	weight_sum = sum_{t}^{T}(weight_{t})
> > 
> > I read your description, but I was distracted by this latex style
> > notation .. Could you walk through in english what these two equation
> > are doing ..
> 
> T is the number of tasks, so the first is the sum of the time every task 
> gets over a period of time and the second is the sum of all weights of 
> each task.

I think I'm more puzzled now than I was before, (scratches head for
minutes) ..

I see .. It's a summation symbol .. 

For instance if there are three tasks in the system. Call them A,B, and
C.

then 

time equals "time of A" + "time of B" + "time of C"

Right? 

Daniel

