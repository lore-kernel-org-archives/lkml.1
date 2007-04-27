Return-Path: <linux-kernel-owner+w=401wt.eu-S1757220AbXD0UiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220AbXD0UiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 16:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757219AbXD0UiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 16:38:08 -0400
Received: from mail.tmr.com ([64.65.253.246]:48711 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757220AbXD0UiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 16:38:07 -0400
Message-ID: <46325F89.408@tmr.com>
Date: Fri, 27 Apr 2007 16:39:37 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
CC: Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org
Subject: Re: Reasons to merge suspend2.
References: <200704251551.38373.a1426z@gawab.com> <alpine.DEB.0.98.0704251111000.18512@sigma.j-a-k-j.com>
In-Reply-To: <alpine.DEB.0.98.0704251111000.18512@sigma.j-a-k-j.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Anthony Kazos Jr. wrote:
>> I didn't read your whole post, it's way too long, but I would like to see 
>> your patch in mainline as an option to swsusp.  What would make this 
>> infeasible?
> 
> For one thing, Linus said not but yesterday that he doesn't want multiple 
> competing suspend algorithms like this in the kernel at once. (If I parsed 
> his message correctly, he doesn't want any in the kernel, but he's putting 
> up with it because it seems somewhat needed.)

My take on what he said also included avoiding putting critical stuff in 
user space, resulting in problems keeping the whole process consistent.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
