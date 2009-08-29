Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868AbZH2XMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbZH2XMx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 19:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbZH2XMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 19:12:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbZH2XMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 19:12:43 -0400
Message-ID: <4A99B5A8.9050201@redhat.com>
Date: Sat, 29 Aug 2009 19:11:36 -0400
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
Subject: Re: [PATCH 08/23] io-controller: cfq changes to use hierarchical
 fair queuing code in elevaotor layer
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <1251495072-7780-9-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1251495072-7780-9-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> Make cfq hierarhical.
> 
> Signed-off-by: Nauman Rafique <nauman@google.com>
> Signed-off-by: Fabio Checconi <fabio@gandalf.sssup.it>
> Signed-off-by: Paolo Valente <paolo.valente@unimore.it>
> Signed-off-by: Aristeu Rozanski <aris@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
