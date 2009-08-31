Return-Path: <linux-kernel-owner+w=401wt.eu-S1754345AbZHaDPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbZHaDPQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 23:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754325AbZHaDPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 23:15:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306AbZHaDPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 23:15:14 -0400
Message-ID: <4A9B3FD3.6000407@redhat.com>
Date: Sun, 30 Aug 2009 23:13:23 -0400
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
Subject: Re: [PATCH 16/23] io-controller: deadline changes for hierarchical
 fair queuing
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <1251495072-7780-17-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1251495072-7780-17-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> This patch changes deadline to use queue scheduling code from elevator layer.
> One can go back to old deadline by selecting CONFIG_IOSCHED_DEADLINE_HIER.
                                     ^ deselecting ?

> Signed-off-by: Nauman Rafique <nauman@google.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
