Return-Path: <linux-kernel-owner+w=401wt.eu-S933816AbXHVR3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933816AbXHVR3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 13:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763875AbXHVR25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 13:28:57 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:33694 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764133AbXHVR24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 13:28:56 -0400
Message-ID: <46CC724A.7020305@linux.vnet.ibm.com>
Date: Wed, 22 Aug 2007 22:58:42 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
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
References: <20070822130612.18981.58696.sendpatchset@balbir-laptop> <20070822094633.733614c5.randy.dunlap@oracle.com>
In-Reply-To: <20070822094633.733614c5.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Wed, 22 Aug 2007 18:36:12 +0530 Balbir Singh wrote:
> 
>>  Documentation/memcontrol.txt |  193 +++++++++++++++++++++++++++++++++++++++++++
> 
> Is there some sub-dir that is appropriate for this, such as
> vm/ or accounting/ or containers/ (new) ?
> 
> 

<snip>

Hi, Randy,

Thanks for the detailed review. Most of the comments seem valid,
I will fix them in the next release.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
