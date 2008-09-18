Return-Path: <linux-kernel-owner+w=401wt.eu-S1757416AbYIRX4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbYIRX4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 19:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756019AbYIRX42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 19:56:28 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:60991 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835AbYIRX41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 19:56:27 -0400
Message-ID: <48D2EA6B.9090504@linux.vnet.ibm.com>
Date: Thu, 18 Sep 2008 16:55:23 -0700
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080725)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, skumar@linux.vnet.ibm.com, yamamoto@valinux.co.jp,
       menage@google.com, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       xemul@openvz.org, kamezawa.hiroyu@jp.fujitsu.com,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [-mm][PATCH 4/4] Add memrlimit controller accounting and control
 (v4)
References: <20080514130904.24440.23486.sendpatchset@localhost.localdomain> <20080514130951.24440.73671.sendpatchset@localhost.localdomain> <20080918135430.e2979ab1.akpm@linux-foundation.org>
In-Reply-To: <20080918135430.e2979ab1.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 14 May 2008 18:39:51 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> This patch adds support for accounting and control of virtual address space
>> limits.
>

[snip]

> 
> could you plese take a look at today's mmotm and see what needs to be
> done to salvage it?  Most of the code you were altering got moved into
> arch/x86/kernel/ds.c and got changed rather a lot.

I'll take a look tonight and see what needs to be done

-- 
	Balbir
