Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbYEEEZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbYEEEZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 00:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbYEEEZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 00:25:08 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:38250 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbYEEEZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 00:25:07 -0400
Message-ID: <481E8BFA.1000903@linux.vnet.ibm.com>
Date: Mon, 05 May 2008 09:54:26 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: kamezawa.hiroyu@jp.fujitsu.com
CC: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [-mm][PATCH 0/4] Add rlimit controller to cgroups (v3)
References: <23630056.1209914669637.kamezawa.hiroyu@jp.fujitsu.com> <20080503213726.3140.68845.sendpatchset@localhost.localdomain> <28343987.1209914862098.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <28343987.1209914862098.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kamezawa.hiroyu@jp.fujitsu.com wrote:
>>   "+This controller framework is designed to be extensible to control any
>>   "+resource limit (memory related) with little effort."
>>   memory only ? Ok, all you want to do is related to memory, but someone
>>   may want to limit RLIMIT_CPU by group or RLIMIT_CORE by group or....
>>   (I have no plan but they seems useful.;)
> ...RLIMIT_MEMLOCK is in my want-to-do-list ;)
> 

Mine too, but I want to get to it after the hierarchy and soft limit patches.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
