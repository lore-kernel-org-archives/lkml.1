Return-Path: <linux-kernel-owner+w=401wt.eu-S1758562AbZBFJdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562AbZBFJdy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 04:33:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756707AbZBFJc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 04:32:27 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59574
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754422AbZBFJcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 04:32:25 -0500
Date: Fri, 06 Feb 2009 01:32:20 -0800 (PST)
Message-Id: <20090206.013220.250415322.davem@davemloft.net>
To: yinghai@kernel.org
Cc: jeff@garzik.org, mingo@elte.hu, akpm@linux-foundation.org,
       aabdulla@nvidia.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] forcedeth: ck804 and mcp55 doesn't need timerirq
From: David Miller <davem@davemloft.net>
In-Reply-To: <498BC43D.6020704@kernel.org>
References: <498BC3A8.9040203@kernel.org>
	<498BC43D.6020704@kernel.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>
Date: Thu, 05 Feb 2009 21:01:49 -0800

> 
> Impact: cleanup
> 
> so get less irq.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Applied to net-next-2.6
