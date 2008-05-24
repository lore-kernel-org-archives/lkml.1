Return-Path: <linux-kernel-owner+w=401wt.eu-S1761444AbYEXSY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761444AbYEXSY4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 14:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759783AbYEXSYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 14:24:46 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:53589 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759449AbYEXSYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 14:24:45 -0400
Message-ID: <48385CFA.7010201@linux.vnet.ibm.com>
Date: Sat, 24 May 2008 23:52:50 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrea Righi <righi.andrea@gmail.com>
CC: menage@google.com, matt@bluehost.com, roberto@unbit.it,
       linux-kernel@vger.kernel.org,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 0/3] cgroup: block device i/o bandwidth controller
References: <> <1211648217-13361-1-git-send-email-righi.andrea@gmail.com>
In-Reply-To: <1211648217-13361-1-git-send-email-righi.andrea@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi wrote:
> I'm resending an updated version of the cgroup I/O bandwidth controller
> that I wrote some months ago (http://lwn.net/Articles/265944), since
> someone asked me recently.
> 
> The goal of this patchset is to implement a block device I/O bandwidth
> controller using cgroups.
> 
> Detailed informations about design, its goal and usage are described in
> the documentation.
> 
> Review, comments and feedbacks are welcome.
> 

Hi, Andrea,

There are several parallel efforts for the IO controller? Could you
describe/compare them with yours? Is any consensus building taking place?

CC'ing containers mailing list.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
