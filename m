Return-Path: <linux-kernel-owner+w=401wt.eu-S1760425AbYLCUX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760425AbYLCUX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:23:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756094AbYLCT5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:57:51 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:38100 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354AbYLCT5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:57:46 -0500
Message-ID: <4936E587.40700@gmail.com>
Date: Wed, 03 Dec 2008 15:01:11 -0500
From: Gregory Haskins <gregory.haskins.ml@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: mingo@elte.hu, rostedt@goodmis.org, peterz@infradead.org,
       linux-kernel@vger.kernel.org, =linux-rt-users@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] Series short description
References: <20081111142323.28477.41235.stgit@dev.haskins.net>
In-Reply-To: <20081111142323.28477.41235.stgit@dev.haskins.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> Hi Ingo, Steven, Peter,
>   This series applies roughly to mainline as an enhancement to the sched_rt
>   logic.  Peter and I were discussing some of the unecessary overhead in
>   pull_rt_tasks() via IRC, and this is my RFC attempt to address the problem.
>   

Hi Ingo,
  I was putting together a refresh of this patch and I rebased on
tip/sched/devel.  I noticed that sched/devel is on 27-rc8, which is
obviously a little stale.  Is this the proper tree to send patches
against, or would you prefer a different HEAD?

-Greg
