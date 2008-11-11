Return-Path: <linux-kernel-owner+w=401wt.eu-S1752263AbYKKTb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbYKKTb5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 14:31:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbYKKTbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 14:31:48 -0500
Received: from zcars04f.nortel.com ([47.129.242.57]:55353 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbYKKTbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 14:31:48 -0500
Message-ID: <4919DD9B.1070104@nortel.com>
Date: Tue, 11 Nov 2008 13:31:39 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: mingo@elte.hu, rostedt@goodmis.org, peterz@infradead.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] Series short description
References: <20081111142323.28477.41235.stgit@dev.haskins.net>
In-Reply-To: <20081111142323.28477.41235.stgit@dev.haskins.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Nov 2008 19:31:43.0469 (UTC) FILETIME=[20B809D0:01C94434]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> Hi Ingo, Steven, Peter,
>   This series applies roughly to mainline as an enhancement to the sched_rt
>   logic.  Peter and I were discussing some of the unecessary overhead in
>   pull_rt_tasks() via IRC, and this is my RFC attempt to address the problem.
> 
>   I have built/booted this on a 4-way C2D Xeon box and it passes preempt-test.

At first blush it looks reasonable, but do you have any performance numbers?

Chris
