Return-Path: <linux-kernel-owner+w=401wt.eu-S1751768AbZHaU7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbZHaU7O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 16:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbZHaU7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 16:59:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbZHaU7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 16:59:13 -0400
Message-ID: <4A9C3951.8020302@redhat.com>
Date: Mon, 31 Aug 2009 16:57:53 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
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
Subject: Re: [PATCH 23/23] io-controller: debug elevator fair queuing support
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <1251495072-7780-24-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1251495072-7780-24-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> o More debugging help to debug elevator fair queuing support. Enabled under
>   CONFIG_DEBUG_ELV_FAIR_QUEUING. Currently it prints vdisktime related
>   trace messages in blktrace.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Is this meant for merging upstream, or just as a temporary
debugging help while this sits in a subsystem tree or -mm?

