Return-Path: <linux-kernel-owner+w=401wt.eu-S1755646AbYHAB7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbYHAB7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 21:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYHAB7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 21:59:00 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30547 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbYHAB67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 21:58:59 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5351"; a="5228985"
Message-ID: <48926DDD.9030003@qualcomm.com>
Date: Thu, 31 Jul 2008 18:58:53 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, menage@google.com,
       a.p.zijlstra@chello.nl, vegard.nossum@gmail.com
Subject: Re: [PATCH] cpuset: Rework sched domains and CPU hotplug handling
References: <1216852381-23445-1-git-send-email-maxk@qualcomm.com> <20080731151421.bb4af984.pj@sgi.com>
In-Reply-To: <20080731151421.bb4af984.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Max,
> 
> What kernel version was this patch against?
> 
> I've tried 2.6.27-rc1-mm1, 2.6.27-rc1, and 2.6.26,
> and it doesn't apply cleanly on any of them.
> 

It was on top of the then latest -tip.
I believe it git automerged it with no conflicts on top of .27-rc1.
I'll resend updated version a bit later.

Max
