Return-Path: <linux-kernel-owner+w=401wt.eu-S1759516AbXLaNw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759516AbXLaNw7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 08:52:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbXLaNwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 08:52:51 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:58030 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbXLaNwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 08:52:50 -0500
Message-ID: <4778F3E5.5010208@linux.vnet.ibm.com>
Date: Mon, 31 Dec 2007 19:21:33 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       dmitry.adamushko@gmail.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC/PATCH 0/3] sched: hrtick and rt group scheduling
References: <20071231001137.147986000@chello.nl>
In-Reply-To: <20071231001137.147986000@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> I spend xmas implementing group scheduling for the realtime scheduling classes.
> Its a tad raw, but seems to work for the trivial test cases I threw at it.
> 

Excellent, will test & review and get back.

> The hrtick stuff is unrelated but was still stuck in my sched queue.
> 
> Patches against .26-rc6-mm1
> 
> --
> 


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
