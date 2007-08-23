Return-Path: <linux-kernel-owner+w=401wt.eu-S1758963AbXHWImT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963AbXHWImT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 04:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbXHWImI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 04:42:08 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:46909 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbXHWImF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 04:42:05 -0400
Message-ID: <46CD478D.5060603@linux.vnet.ibm.com>
Date: Thu, 23 Aug 2007 14:08:37 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Containers <containers@lists.osdl.org>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, Dave Hansen <haveblue@us.ibm.com>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       Nick Piggin <npiggin@suse.de>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric W Biederman <ebiederm@xmission.com>
Subject: Re: [PATCH] Memory controller Add Documentation
References: <20070822130612.18981.58696.sendpatchset@balbir-laptop> <20070823173621.4539b376.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070823173621.4539b376.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> Thank you for documentaion. How about adding following topics ?
> 
> - Benefit and Purpose. When this function help a user.
> - What is accounted as RSS.
> - What is accounted as page-cache.
> - What are not accoutned now.
> - When a page is accounted (charged.)
> - about mem_control_type
> - When a user can remove memory controller with no tasks (by rmdir)
>   and What happens if a user does.
> - What happens when a user migrates a task to other container.
> 

Thanks for your input. I'll try and incorporate your comments into
the documentation (I think it will help developers and users alike).

> Writing all above may be too much :)
> 
> I'm sorry if I say something pointless.
> 

No.. not at all! Thank you for reading the documentation and commenting
on it.

> Thanks,
> -Kame
> 
> 


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
