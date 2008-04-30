Return-Path: <linux-kernel-owner+w=401wt.eu-S933455AbYD3WIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455AbYD3WIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764691AbYD3WGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:06:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:50559 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933831AbYD3WGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:06:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=AHhibacVeW63X13U5fOUjfTzaeTsFITfZGHAaDR7B3L9fAmpQTUEXPkBSZxdDnQrQNQXAevFlfQUJVbg1m0NbcUngVLuNVL4vy9XY3L0GwgVLiqdVo/geERrq83YvCGWji4d8Mhpcb6Jd2Bx79QrMOx1wqwh5jDZbo/rLc91R8I=
Message-ID: <4818ED61.9020002@gmail.com>
Date: Thu, 01 May 2008 00:06:25 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, rjw@sisk.pl,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Slow DOWN, please!!!
References: <20080429.190352.137408408.davem@davemloft.net>	<200804302136.58005.rjw@sisk.pl>	<20080430131537.1f7a0914.akpm@linux-foundation.org>	<alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org> <20080430135405.ddc42075.akpm@linux-foundation.org> <4818E7E3.7080705@gmail.com>
In-Reply-To: <4818E7E3.7080705@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2008 11:42 PM, Dmitri Vorobiev wrote:
> For busy (or lazy) people like myself, the big problem with linux-next are
> the frequent merge breakages, when pulling the tree stops with "you are in
> the middle of a merge conflict". Perhaps, there is a better way to resolve
> this without just removing the whole repo and cloning it once again - this

If this is still an issue of -next, I would say we won't get too much testers. I 
gave up after first time I was attacked by that and got back to pure -mm.

I think greg-kh asked why this happens (Stephen rebases?), if you search 
archives, I'm sure you'll find it.
