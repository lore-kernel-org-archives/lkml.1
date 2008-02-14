Return-Path: <linux-kernel-owner+w=401wt.eu-S932666AbYBNMo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666AbYBNMo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 07:44:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760630AbYBNMor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 07:44:47 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:36546 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759223AbYBNMoq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 07:44:46 -0500
Date: Thu, 14 Feb 2008 07:38:03 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Shi Weihua <shiwh@cn.fujitsu.com>
cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       khilman@mvista.com, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2.6.24-rt1] timer:fix build warning in timer.c
In-Reply-To: <47B411A6.9030007@cn.fujitsu.com>
Message-ID: <Pine.LNX.4.58.0802140737370.20595@gandalf.stny.rr.com>
References: <47B411A6.9030007@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 14 Feb 2008, Shi Weihua wrote:

> Fix the following compile warning without CONFIG_PREEMPT_RT:
> kernel/timer.c:937: warning: ‘count_active_rt_tasks’ defined but not used
>
> Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com>

Thanks, applied.

-- Steve

