Return-Path: <linux-kernel-owner+w=401wt.eu-S1751456AbZH2Bqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456AbZH2Bqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 21:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750882AbZH2Bqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 21:46:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbZH2Bqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 21:46:34 -0400
Message-ID: <4A988814.6090906@redhat.com>
Date: Fri, 28 Aug 2009 21:44:52 -0400
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
Subject: Re: [PATCH 04/23] io-controller: Modify cfq to make use of flat elevator
 fair queuing
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <1251495072-7780-5-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1251495072-7780-5-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> This patch changes cfq to use fair queuing code from elevator layer.
> 
> Signed-off-by: Nauman Rafique <nauman@google.com>
> Signed-off-by: Fabio Checconi <fabio@gandalf.sssup.it>
> Signed-off-by: Paolo Valente <paolo.valente@unimore.it>
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
