Return-Path: <linux-kernel-owner+w=401wt.eu-S934141AbXGMNs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934141AbXGMNs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 09:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757103AbXGMNsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 09:48:09 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:58554 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759540AbXGMNsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 09:48:07 -0400
Message-ID: <46978299.7040908@bx.jp.nec.com>
Date: Fri, 13 Jul 2007 22:48:09 +0900
From: KII Keiichi <k-keiichi@bx.jp.nec.com>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>, Netdev <netdev@vger.kernel.org>,
       Joel Becker <joel.becker@oracle.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2 -mm 7/9] netconsole: Use netif_running() in write_msg()
References: <20070710091920.23907.96483.sendpatchset@cselinux1.cse.iitk.ac.in> <20070710091956.23907.61655.sendpatchset@cselinux1.cse.iitk.ac.in>
In-Reply-To: <20070710091956.23907.61655.sendpatchset@cselinux1.cse.iitk.ac.in>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Satyam,

> From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> 
> [7/9] netconsole: Use netif_running() in write_msg()
> 
> Avoid unnecessarily disabling interrupts and calling netpoll_send_udp()
> if the corresponding local interface is not up.
> 
> Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> Cc: Keiichi Kii <k-keiichi@bx.jp.nec.com>
> 
Acked-by: Keiichi Kii <k-keiichi@bx.jp.nec.com>

Thanks
--
Keiichi KII
NEC Corporation OSS Platform Development Division
E-mail: k-keiichi@bx.jp.nec.com

