Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbYEFLCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbYEFLCM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 07:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbYEFLB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 07:01:56 -0400
Received: from rudy.mif.pg.gda.pl ([153.19.42.16]:32522 "EHLO
	rudy.mif.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbYEFLBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 07:01:55 -0400
Date: Tue, 6 May 2008 13:02:55 +0200 (CEST)
From: =?ISO-8859-2?Q?Tomasz_K=B3oczko?= <kloczek@rudy.mif.pg.gda.pl>
To: FD Cami <francois.cami@free.fr>
cc: Kevin Burton <burtonator@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Ability to limit or disable page caching?
In-Reply-To: <20080505212831.22371732@olorin>
Message-ID: <Pine.BSO.4.63.0805061302080.3770@rudy.mif.pg.gda.pl>
References: <30c6373b0805050012o505c0540i116a31bc1ab9ce9f@mail.gmail.com>
 <20080505131607.5556b1f2@olorin> <30c6373b0805051134m634efbbdn45167c1eae29df4a@mail.gmail.com>
 <20080505212831.22371732@olorin>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-171882422-1210071775=:3770"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-171882422-1210071775=:3770
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT

On Mon, 5 May 2008, FD Cami wrote:

> On Mon, 5 May 2008 11:34:24 -0700
> "Kevin Burton" <burtonator@gmail.com> wrote:
>
>>>> In the mean time is it possible to disable the page cache or limit it
>>>> to say 10% of system memory?
>>>
>>> You might want to look at /proc/sys/vm/ for tunables.
>>> /proc/sys/vm/vfs_cache_pressure and /proc/sys/vm/swappiness are probably
>>> what you are looking for.
>>
>> I haven't played with vfs_cache_pressure so I'll take a look at this.
>>
>> Unfortunately, swappiness doesn't work as intended.
>
> Could you explain the original problem ? That way we might help you better.

Probably it is something like this:

http://blogs.smugmug.com/don/2008/05/01/mysql-and-the-linux-swap-problem/

kloczek
-- 
-----------------------------------------------------------
*Ludzie nie maj± problemów, tylko sobie sami je stwarzaj±*
-----------------------------------------------------------
Tomasz K³oczko | *e-mail: kloczek@rudy.mif.pg.gda.pl*
--0-171882422-1210071775=:3770--
