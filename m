Return-Path: <linux-kernel-owner+w=401wt.eu-S1751820AbYGVEHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbYGVEHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 00:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750707AbYGVEHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 00:07:33 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1747 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbYGVEHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 00:07:32 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5343"; a="4938487"
Message-ID: <48855D05.1000900@qualcomm.com>
Date: Mon, 21 Jul 2008 21:07:33 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl, rostedt@goodmis.org,
       vegard.nossum@gmail.com
Subject: Re: [PATCH] cpu hotplug: Make cpu_active_map synchronization	dependency
 clear
References: <1216180586-8313-1-git-send-email-maxk@qualcomm.com> <20080718112635.GA6875@elte.hu> <20080718120312.GA9926@elte.hu>
In-Reply-To: <20080718120312.GA9926@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> * Max Krasnyansky <maxk@qualcomm.com> wrote:
>>
>>> This goes on top of the cpu_active_map (take 2) patch.
>> i've applied it to sched/devel. [...]
> 
> build fix below for UP.

Thanks for fixing this (and the spaces and stuff).

Max
