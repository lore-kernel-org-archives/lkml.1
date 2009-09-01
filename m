Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbZIALqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbZIALqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 07:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbZIALqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 07:46:32 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42640 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbZIALqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 07:46:31 -0400
Message-ID: <131e030829a2333d9e0de29783133335.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0909011217440.18858@sister.anvils>
References: <200908272355.n7RNtghC019990@imap1.linux-foundation.org>
    <20090901180032.55f7b8ca.kamezawa.hiroyu@jp.fujitsu.com>
    <Pine.LNX.4.64.0909011031140.13740@sister.anvils>
    <20090901185013.c86bd937.kamezawa.hiroyu@jp.fujitsu.com>
    <20090901191018.19a69696.kamezawa.hiroyu@jp.fujitsu.com>
    <Pine.LNX.4.64.0909011158080.17324@sister.anvils>
    <Pine.LNX.4.64.0909011217440.18858@sister.anvils>
Date: Tue, 1 Sep 2009 20:46:31 +0900 (JST)
Subject: Re: [mmotm][BUG] free is bigger than presnet Re: mmotm
 2009-08-27-16-51 uploaded
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Hugh Dickins" <hugh.dickins@tiscali.co.uk>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, hannes@cmpxchg.org
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Tue, 1 Sep 2009, Hugh Dickins wrote:
>> On Tue, 1 Sep 2009, KAMEZAWA Hiroyuki wrote:
>> >
>> > Sorry again, at continuing tests...thre are still..
>> >
>> > MemTotal:       24421124 kB
>> > MemFree:        25158956 kB
>> > Buffers:            2264 kB
>> > Cached:            34936 kB
>> > SwapCached:         5140 kB
>> >
>> > I wonder I miss something..
>>
>> I've not been looking at /proc/meminfo: I'll do some stuff and see
>> if it goes wrong for me too, will let you know if so.
>
> Well, I've not yet noticed unbelievable MemFree, but my Active(anon)
> (and Active) is bigger than my MemTotal and rising each iteration.
>
> Probably not directly related to your case, and probably related to
> my tmpfs or loop use: but I'd better pursue the anomaly I can so
> easily reproduce, than worry about the anomaly you can reproduce.
>
I'll dig more. (After dinner, I doubt myself ;)

> Good luck with yours!
you too.

-Kame

