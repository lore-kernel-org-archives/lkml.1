Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183AbYKFWa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbYKFWa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 17:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbYKFWal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 17:30:41 -0500
Received: from zcars04f.nortel.com ([47.129.242.57]:40022 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbYKFWak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 17:30:40 -0500
Message-ID: <49136FF0.1060801@nortel.com>
Date: Thu, 06 Nov 2008 16:30:08 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Ingo Molnar <mingo@elte.hu>, Ken Chen <kenchen@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [patch] sched: fix single-depth wchan output
References: <b040c32a0811052158r4f6662dega3503a0c7ec72620@mail.gmail.com> <20081106061125.GA6384@elte.hu> <1226008571.3023.20.camel@calx>
In-Reply-To: <1226008571.3023.20.camel@calx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Nov 2008 22:30:12.0668 (UTC) FILETIME=[3BD55FC0:01C9405F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Thu, 2008-11-06 at 07:11 +0100, Ingo Molnar wrote:

>>How about adding a /proc/<PID>/stacktrace file that gives us the stack 
>>trace of any task in the system? That would be useful for a number of 
>>other purposes as well, and about 100 times more useful than wchan. 
>>(often it would be more useful than sysrq-t dumps)
> 
> 
> But this is a great idea, of course.

Agreed.  I know some apps designers that would love to get their hands 
on something like that...



Chris
