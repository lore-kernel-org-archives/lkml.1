Return-Path: <linux-kernel-owner+w=401wt.eu-S1760119AbYEAMbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760119AbYEAMbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 08:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965AbYEAMbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 08:31:39 -0400
Received: from mail.netone.net.tr ([193.192.98.182]:13307 "EHLO
	mail.netone.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124AbYEAMbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 08:31:38 -0400
Message-ID: <4819B828.1060408@netone.net.tr>
Date: Thu, 01 May 2008 15:31:36 +0300
From: Tarkan Erimer <tarkan@netone.net.tr>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, rjw@sisk.pl,
       davem@davemloft.net, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
References: <20080429.190352.137408408.davem@davemloft.net>	<200804302245.50817.rjw@sisk.pl>	<alpine.LFD.1.10.0804301422350.2980@woody.linux-foundation.org>	<200805010023.32213.rjw@sisk.pl>	<alpine.LFD.1.10.0804301530360.2980@woody.linux-foundation.org> <20080430154124.7ec08dd4.akpm@linux-foundation.org>
In-Reply-To: <20080430154124.7ec08dd4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 May 2008 12:29:23.0136 (UTC) FILETIME=[FC909400:01C8AB86]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> So David's Subject: should have been "Do Better, please".  Slowing down is
> just a side-effect.  And, we expect, a tool.
>
>   
To improve the quality of kernel releases, maybe we can create a special 
kernel testing tool.
This tool should have :

- Can check known bugs, regressions, compile errors etc.

- The design should be modular (plug-in support). So, easily these 
regressions, known bugs etc. should be implemented.

- It should have a git support. So,when hit a bug, this tool should have 
ability to bisect the commits which automates to finding buggy commits.

- It should have console interface and X interface. So; not just 
developers, also users, who wants to help to find out the issues, can 
contribute easily.

Just a few things came to my mind when thought about it. Any more 
ideas/suggestions welcomed :-) Also, we can create a web site for this 
project and we can identify the known regressions, bugs etc. So, easily 
who wants to contribute some code about this tool, easily find out these 
issues. If anyone interests to create/lead such a tool like this, I can 
host a website about this project on our system.

Cheers

Tarkan



