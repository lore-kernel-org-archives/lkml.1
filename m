Return-Path: <linux-kernel-owner+w=401wt.eu-S932626AbXLORBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626AbXLORBA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 12:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758077AbXLORAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 12:00:50 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:59510 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbXLORAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 12:00:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=ZEhNTcLjbmb8Z86YcDZOVw/EkrnsEo2VvCQtHC0CYWTCd3Rz8recUlVEEru89HYXlXGrAHi0XzJ+OHDX9mKySHJaF3tpPrRdAt13gBn9meN9bbEmK2Sd4bZQbgOXFF9BKcZhRZGL03s3Xd7BdgiVfmWyaRkPWuJL7ras9Fs8BNQ=
Message-ID: <4764099B.2070804@gmail.com>
Date: Sat, 15 Dec 2007 18:06:35 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Icedove 1.5.0.14pre (X11/20071020)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Miles Lane <miles.lane@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: 2.6.24-rc5-mm1 -- inconsistent {in-softirq-W} -> {softirq-on-R}
   usage.
References: <a44ae5cd0712141413u4ddbfd06gca259cfc3bc0ab1a@mail.gmail.com>	<20071214153633.5d8f609a.akpm@linux-foundation.org>	<a44ae5cd0712141958o10d9a320h3b8173019ac6b0eb@mail.gmail.com> <20071215031341.66dc0d05.akpm@linux-foundation.org>
In-Reply-To: <20071215031341.66dc0d05.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote, On 12/15/2007 12:13 PM:

> On Fri, 14 Dec 2007 22:58:24 -0500 "Miles Lane" <miles.lane@gmail.com> wrote:
> 
>> On Dec 14, 2007 6:36 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>>> On Fri, 14 Dec 2007 17:13:21 -0500
>>> "Miles Lane" <miles.lane@gmail.com> wrote:
...
>>>> Pid: 6944, comm: cat Not tainted (2.6.24-rc5-mm1 #26)

...

>>>> note: cat[6944] exited with preempt_count 4

...

>> Dec 14 21:32:55 feargod kernel: cat/6180 is trying to release lock

...

> Can you suggest a way in which others can reproduce this?

Buy a cat?

Jarek P.
