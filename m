Return-Path: <linux-kernel-owner+w=401wt.eu-S1755132AbZFRH0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbZFRH0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 03:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbZFRH0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 03:26:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45361
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751460AbZFRH0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 03:26:02 -0400
Date: Thu, 18 Jun 2009 00:26:05 -0700 (PDT)
Message-Id: <20090618.002605.92822150.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: robert.olsson@its.uu.se, zheng.yan@oracle.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 3/1] Re: [BUG] fib_tries related Oops in 2.6.30
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090618072300.GA6243@ff.dom.local>
References: <20090615160800.GC2767@ami.dom.local>
	<20090617.185658.226201750.davem@davemloft.net>
	<20090618072300.GA6243@ff.dom.local>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Thu, 18 Jun 2009 07:23:00 +0000

> ipv4: Fix fib_trie rebalancing, part 3
> 
> Alas my fix, part 2, has one if too much again... (We can't repeat the
> same test because tn is different.)
> 
> Reported-by: Yan Zheng <zheng.yan@oracle.com>
> Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>

Since I didn't push patch #2 out yet I'll combine it with
this one.
