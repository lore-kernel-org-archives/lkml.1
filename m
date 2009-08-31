Return-Path: <linux-kernel-owner+w=401wt.eu-S1754442AbZHaTvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbZHaTvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 15:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853AbZHaTvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 15:51:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819AbZHaTvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 15:51:21 -0400
Message-ID: <4A9C2946.4070006@redhat.com>
Date: Mon, 31 Aug 2009 15:49:26 -0400
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
Subject: Re: [PATCH 21/23] io-controller: Per io group bdi congestion interface
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <1251495072-7780-22-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1251495072-7780-22-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> o So far there used to be only one pair or queue  of request descriptors
>   (one for sync and one for async) per device and number of requests allocated
>   used to decide whether associated bdi is congested or not.

Acked-by: Rik van Riel <riel@redhat.com>
