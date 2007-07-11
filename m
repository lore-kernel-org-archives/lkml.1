Return-Path: <linux-kernel-owner+w=401wt.eu-S932356AbXGKAGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356AbXGKAGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 20:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761379AbXGKAGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 20:06:36 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:49781
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758982AbXGKAGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 20:06:35 -0400
Date: Tue, 10 Jul 2007 17:01:17 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Adrian Bunk <bunk@stusta.de>
cc: Valdis.Kletnieks@vt.edu, Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22 released
In-Reply-To: <20070710222652.GE3492@stusta.de>
Message-ID: <Pine.LNX.4.64.0707101659250.1626@asgard.lang.hm>
References: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org>
 <25865.1184096391@turing-police.cc.vt.edu> <20070710222652.GE3492@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007, Adrian Bunk wrote:

> On Tue, Jul 10, 2007 at 03:39:51PM -0400, Valdis.Kletnieks@vt.edu wrote:
>> On Sun, 08 Jul 2007 16:52:52 PDT, Linus Torvalds said:
>>
>>> The full changelog since 2.6.21 also got uploaded, but quite frankly, I
>>> wonder if anybody uses those things? I've been uploading them for non-git
>>> users, but I have a suspicion that any people who want that kind of
>>> detail have long since learnt to use git, or are following the commit
>>> mailing lists or equivalent.
>>
>> What the Rest Of The World could probably use is if some kind soul were to go
>> through and build a .21->.22 document that lists all the *userspace visible*
>> changes (new drivers, new filesystems/features, new/changed stuff in /sys and
>> /proc, new ioctls, new and changed Kconfig, etc).
>> ...
>
> Already available:
>  http://kernelnewbies.org/Linux_2_6_22
>
> Credits for it go to Diego Calleja.
>
> It's a Wiki, so if you miss anything there you can add it yourself.
>
> It might make sense if Linus would give a link to the corresponding
> changelog there in future release announcements.

lwn.net has a series on the API changes, they don't try to cover all the 
drivers, but they should cover all the things that a driver writer would 
need to worry about

http://lwn.net/Kernel/

David Lang
