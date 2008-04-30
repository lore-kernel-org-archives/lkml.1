Return-Path: <linux-kernel-owner+w=401wt.eu-S1763825AbYD3XEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763825AbYD3XEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 19:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757270AbYD3XE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 19:04:27 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:41426 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756575AbYD3XE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 19:04:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=ggp/+xeo61w6lkHGz+40ujRywotowlmWytiEE6EPEnEUniGyBX5mPFl6S5t2GueSlE7uFeFUrc+Jk+Ka+fjlolUX/tciixFejZTf+ZK+2wuGs4uBZ61ofvRXLihpeePx+3U6ahG752WZ97ay+72ITnQAeVGySbI/ihqz5xwK7W4=
Message-ID: <4818FAF2.9020207@gmail.com>
Date: Thu, 01 May 2008 03:04:18 +0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: torvalds@linux-foundation.org, rjw@sisk.pl, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com, mingo@elte.hu
Subject: Re: Slow DOWN, please!!!
References: <20080429.190352.137408408.davem@davemloft.net>	<200804302136.58005.rjw@sisk.pl>	<20080430131537.1f7a0914.akpm@linux-foundation.org>	<alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>	<20080430135405.ddc42075.akpm@linux-foundation.org>	<4818E7E3.7080705@gmail.com> <20080430151007.0ace4fa2.akpm@linux-foundation.org>
In-Reply-To: <20080430151007.0ace4fa2.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton пишет:

[skipped]

>> Finally, while the list is at it, I'd like to make another technical comment.
>> My development zoo is a pretty fast 4-way Xeon server, where I keep a handful
>> of trees, a few cross-toolchains, Qemu, etc. The network setup in our
>> organization is such that I can use git only over http from that server.
> 
> Don't know what to do about that, sorry.  An off-site git->http proxy might
> work, but I doubt if anyone has written the code.

But there is another solution, which I believe is straightforward: have the tree
maintainer set up his tree properly.

Dmitri

> 
> 

