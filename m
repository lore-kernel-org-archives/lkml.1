Return-Path: <linux-kernel-owner+w=401wt.eu-S1754928AbXDZRog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbXDZRog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbXDZRog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:44:36 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754927AbXDZRof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:44:35 -0400
Date: Thu, 26 Apr 2007 10:44:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bill Davidsen <davidsen@tmr.com>
cc: Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
In-Reply-To: <4630E3C4.20003@tmr.com>
Message-ID: <alpine.LFD.0.98.0704261043170.9964@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>
 <20070426040806.GJ3468@stusta.de> <20070426125802.GL3468@stusta.de>
 <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org>
 <4630E3C4.20003@tmr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Apr 2007, Bill Davidsen wrote:
>
> If the result is fixing things which then don't get fixed in mainline, as
> Adrian notes

That whole premise is flawed. The *rule* for the stable tree is that 
things don't get merged into the stable tree unless they are fixed in 
mainline already. 

We had that problem in the 2.4.x / 2.5.x split. I think we learnt our 
lesson.

			Linus
