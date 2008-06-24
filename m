Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbYFXCoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbYFXCoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 22:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbYFXCoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 22:44:46 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36529 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbYFXCop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 22:44:45 -0400
Date: Tue, 24 Jun 2008 11:43:09 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] putback_lru_page()/unevictable page handling rework v3
Cc: kosaki.motohiro@jp.fujitsu.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080621185408.E832.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080621185408.E832.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20080624114006.D81C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> I merged kamezawa-san's SHMEM related fix.
> this patch works well >2H.
> and, I am going to test on stress workload during this week end.
> 
> but I hope recieve review at first.
> thus I post it now.

Unfortunately, my machine crashed last night ;-)
I'll dig it.


