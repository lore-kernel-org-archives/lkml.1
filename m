Return-Path: <linux-kernel-owner+w=401wt.eu-S1754425AbYK1LH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbYK1LH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 06:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbYK1LHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 06:07:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57723
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752277AbYK1LHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 06:07:07 -0500
Date: Fri, 28 Nov 2008 03:07:07 -0800 (PST)
Message-Id: <20081128.030707.31836881.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] pkt_sched: fix sparse warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <492fbbfd.190c660a.1db3.fffffcc3@mx.google.com>
References: <492fbbfd.190c660a.1db3.fffffcc3@mx.google.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Thu, 27 Nov 2008 20:33:17 +0100

> Impact: make global function static
> 
> Fix the following sparse warning:
> 
>   net/sched/sch_api.c:192:14: warning: symbol 'qdisc_match_from_root' was not declared. Should it be static?
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Applied, thanks Hannes.
