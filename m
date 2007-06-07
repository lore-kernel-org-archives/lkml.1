Return-Path: <linux-kernel-owner+w=401wt.eu-S936381AbXFGUXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936381AbXFGUXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 16:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763399AbXFGUXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 16:23:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43032
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1762479AbXFGUXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 16:23:24 -0400
Date: Thu, 07 Jun 2007 13:23:39 -0700 (PDT)
Message-Id: <20070607.132339.82695611.davem@davemloft.net>
To: dada1@cosmosbay.com
Cc: penguin-kernel@I-love.SAKURA.ne.jp, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [2.6.22-rc4] UDP's local port assignment not working correctly.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070607151839.d8f1c164.dada1@cosmosbay.com>
References: <200706072040.BEC00116.MQFFtSOVOHFOLJ@I-love.SAKURA.ne.jp>
	<20070607151839.d8f1c164.dada1@cosmosbay.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Thu, 7 Jun 2007 15:18:39 +0200

> Yes, this was discovered two days ago and David reverted four commits.
> 
> http://git.kernel.org/?p=linux/kernel/git/davem/net-2.6.git;a=commitdiff;h=82c5fde20031375cd93fa5a247cf15603ea1f152
> 
> So it should probably be included in Linus tree very very soon.

Right.
