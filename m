Return-Path: <linux-kernel-owner+w=401wt.eu-S1759044AbYESIYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759044AbYESIYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 04:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516AbYESIYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 04:24:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59339 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755346AbYESIYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 04:24:30 -0400
Message-ID: <483138AC.9080504@cn.fujitsu.com>
Date: Mon, 19 May 2008 16:22:04 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.26-rc3
References: <alpine.LFD.1.10.0805181440310.32253@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805181440310.32253@woody.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds said the following on 2008-5-19 6:12:
> So because of that event, I looked at some of the statistics of the BK 
> timeframe and the git timeframe. The most striking difference has nothing 
> to do with git or BK (the switch-over timing was just the reason I decided 
> to take a look), but with the fact that we're not just continuing to 
> develop, but we're developing faster and with more people.
> 
> So during the three years 2002->2005, we had 63428 commits, attributed to 
> 1560 different authors (caveat: misspellings etc will mean that some 
> people get counted more than ones). During the last three years, we've had 
> 96885 attributed to 4068 distinct authors (with the same caveat, 
> obviously).
> 
> I didn't do a lot of per-commit statistics yet, but from the little I've 
> done it also seems like we've gotten increasingly better at doing small 
> commits (which is probably one of the reasons we have a larger number of 
> them, but also why we have more authors - small commits is how people get 
> into doing kernel development).
> 
> [ But part of it is also because we're better at authorship tracking: the 
>   BK history has 6000+ patches attributed to Andrew, and a number of them
>   have a "From: xyz" in them, but my statistics only looked at who got
>   attributed in the SCM logs.  Our patch extraction tools have also gotten 
>   better over the years.. ]
> 
> I'll see if I can make some interesting statistics about just how 
> development has changed over the last three years, but no promises. The 
> actual exact "same amount of time" time is coming up in another month or 
> so.
> 

Linus, I've made an analysis from raw data of git-log. Very similar to what
Jonathan Corbet has done. But hope it can give us some useful information.
http://remword.com/kps_result/

--WCN

