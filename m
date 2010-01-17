Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334Ab0AQInP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab0AQInP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 03:43:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704Ab0AQInO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 03:43:14 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:44452 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab0AQInN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 03:43:13 -0500
Message-ID: <4B52CDA0.7050909@pardus.org.tr>
Date: Sun, 17 Jan 2010 10:43:12 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Yinghai Lu <yinghai@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       hpa@zytor.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       jaswinder@kernel.org, stable@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Boot hangs after "Freeing initrd memory" with 2.6.31.11
References: <4B4E1633.8010700@pardus.org.tr> <4B4F1DE7.307@pardus.org.tr> <4B51B0E8.1010302@pardus.org.tr> <201001162312.34189.rjw@sisk.pl>
In-Reply-To: <201001162312.34189.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Saturday 16 January 2010, Ozan Çağlayan wrote:

>>>
>>> I think that the commit should be reverted or a fix should be released for linux-2.6 tree,
>>> as well as .31 and .32 stable trees.
>>
>> Linux 2.6.31 is released on Sep 9th. So people having an Athlon XP processor + a kernel newer than 4 months
>> which enables CONFIG_X86_CPU_DEBUG can't even boot into a linux kernel. I was *at least* expecting a comment from the relevant
>> people but nope for 2 days.
>>
>> It seems to be a serious regression which doesn't get caught. I'm also CC'ing Rafael, maybe he can inject this
>> in one of his regression threads.
> 
> Well, the problem is I'm not listing regressions from 2.6.31 any more.

Yes you're right.

> 
> Also, I don't have hardware to reproduce the problem on.
> 
> Is there a bug entry for this in the kernel Bugzilla?

Nope not for now, I'll do that.
