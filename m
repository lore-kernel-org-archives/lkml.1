Return-Path: <linux-kernel-owner+w=401wt.eu-S1752871AbZH3AL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbZH3AL1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 20:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbZH3AL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 20:11:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbZH3AL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 20:11:26 -0400
Message-ID: <4A99C37A.1020809@redhat.com>
Date: Sat, 29 Aug 2009 20:10:34 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH 10/23] io-controller: Debug hierarchical IO scheduling
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <1251495072-7780-11-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1251495072-7780-11-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> o Littile debugging aid for hierarchical IO scheduling.
> 
> o Enabled under CONFIG_DEBUG_GROUP_IOSCHED
> 
> o Currently it outputs more debug messages in blktrace output which helps
>   a great deal in debugging in hierarchical setup. It also creates additional
>   cgroup interfaces io.disk_queue and io.disk_dequeue to output some more
>   debugging data.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
