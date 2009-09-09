Return-Path: <linux-kernel-owner+w=401wt.eu-S1752773AbZIII3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbZIII3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 04:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbZIII3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 04:29:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34068
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752403AbZIII3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 04:29:48 -0400
Date: Wed, 09 Sep 2009 01:30:04 -0700 (PDT)
Message-Id: <20090909.013004.213657550.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: __hw_perf_counter_init() on x86
From: David Miller <davem@davemloft.net>
In-Reply-To: <1252483487.7746.164.camel@twins>
References: <20090908.234918.174793485.davem@davemloft.net>
	<1252483487.7746.164.camel@twins>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed, 09 Sep 2009 10:04:47 +0200

> Subject: perf_counter: x86: Fix PMU resource leak
> 
> Dave noticed that we leak the PMU resource reservations when we fail the
> hardware counter init.
> 
> Reported-by: David Miller <davem@davemloft.net>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Looks great.

Acked-by: David S. Miller <davem@davemloft.net>
