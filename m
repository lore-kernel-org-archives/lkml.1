Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbZHYDhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbZHYDhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 23:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754183AbZHYDhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 23:37:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171AbZHYDhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 23:37:19 -0400
Message-ID: <4A935C3F.10207@redhat.com>
Date: Mon, 24 Aug 2009 23:36:31 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, ryov@valinux.co.jp,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, m-ikeda@ds.jp.nec.com,
       agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org,
       jmarchan@redhat.com
Subject: Re: [PATCH 01/24] io-controller: Documentation
References: <1250451046-9966-1-git-send-email-vgoyal@redhat.com> <1250451046-9966-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1250451046-9966-2-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> o Documentation for io-controller.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

IMHO the IO scheduler is the right place to do IO scheduling,
so this gets my ACK :)

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
