Return-Path: <linux-kernel-owner+w=401wt.eu-S1761320AbXLRDgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761320AbXLRDgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 22:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbXLRDgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 22:36:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbXLRDgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 22:36:10 -0500
Message-ID: <47674011.2050905@redhat.com>
Date: Mon, 17 Dec 2007 22:35:45 -0500
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: mingo@elte.hu, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, Clark Williams <williams@redhat.com>
Subject: Re: [PATCH] sched: dynamically update the root-domain span/online
 maps
References: <20071218023805.4390.19471.stgit@novell1.haskins.net>
In-Reply-To: <20071218023805.4390.19471.stgit@novell1.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> Hi Steven,
>   I posted a suspend-to-ram fix to sched-devel earlier today:
> 
> http://lkml.org/lkml/2007/12/17/445
> 
> This fix should also be applied to -rt as I introduced the same regression
> there.  Here is a version of the fix for 23-rt13.  I can submit a version for
> 24-rc5-rt1 at your request.
> 

Thanks Gregory,

I'll put this into the 2.6.23.11-rt14 queue. I have someone that tells 
me that suspend to RAM breaks. I'll have him try the new update and let 
me know if it fixes his issue before releasing it. I'll also let 
everyone know the results as well.

-- Steve
