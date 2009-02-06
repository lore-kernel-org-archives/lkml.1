Return-Path: <linux-kernel-owner+w=401wt.eu-S1757855AbZBFJby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855AbZBFJby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 04:31:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755689AbZBFJbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 04:31:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59559
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754583AbZBFJbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 04:31:32 -0500
Date: Fri, 06 Feb 2009 01:31:28 -0800 (PST)
Message-Id: <20090206.013128.109083992.davem@davemloft.net>
To: yinghai@kernel.org
Cc: jeff@garzik.org, mingo@elte.hu, akpm@linux-foundation.org,
       aabdulla@nvidia.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] forcedeth: don't clear nic_poll_irq too early
From: David Miller <davem@davemloft.net>
In-Reply-To: <498BC3EE.3070209@kernel.org>
References: <498BC3A8.9040203@kernel.org>
	<498BC3EE.3070209@kernel.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>
Date: Thu, 05 Feb 2009 21:00:30 -0800

> 
> Impact: fix bug
> 
> for msix, we still need that flag to enable irq respectively
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Applied to net-next-2.6
