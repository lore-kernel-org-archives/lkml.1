Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbYE3Hhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbYE3Hhv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 03:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbYE3Hhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 03:37:43 -0400
Received: from mail.netone.net.tr ([193.192.98.182]:22740 "EHLO
	mail.netone.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbYE3Hhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 03:37:43 -0400
Message-ID: <483FAEC4.1030607@netone.net.tr>
Date: Fri, 30 May 2008 10:37:40 +0300
From: Tarkan Erimer <tarkan@netone.net.tr>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.25.4-rt4
References: <1212076754.24785.18.camel@localhost.localdomain>
In-Reply-To: <1212076754.24785.18.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 May 2008 07:35:11.0198 (UTC) FILETIME=[B12B57E0:01C8C227]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> We are pleased to announce the 2.6.25.4-rt4 tree, which can be
> downloaded from the location:
>
>   

Hi,

I just downloaded and tried to compile it. But I got the following error 
message at compile stage. I use Kubuntu-8.04 with linux-2.6.25.4-rt3 
without problems.

kernel/sched.c: In function 'sched_init':
kernel/sched.c:7677: error: implicit declaration of function 
'global_rt_runtime'
make[2]: *** [kernel/sched.o] Error 1
make[1]: *** [kernel] Error 2
make[1]: Leaving directory `/usr/src/linux-2.6.25.4'
make: *** [debian/stamp-build-kernel] Error 2





