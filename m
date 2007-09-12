Return-Path: <linux-kernel-owner+w=401wt.eu-S1765851AbXILNRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765851AbXILNRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 09:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757139AbXILNR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 09:17:28 -0400
Received: from 74-93-104-98-Washington.hfc.comcastbusiness.net ([74.93.104.98]:35975
	"EHLO picasso.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755962AbXILNR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 09:17:27 -0400
Date: Wed, 12 Sep 2007 06:17:06 -0700 (PDT)
Message-Id: <20070912.061706.15251290.davem@davemloft.net>
To: bunk@kernel.org
Cc: yjwei@cn.fujitsu.com, vladislav.yasevich@hp.com, sri@us.ibm.com,
       linux-kernel@vger.kernel.org, lksctp-developers@lists.sourceforge.net,
       netdev@vger.kernel.org
Subject: Re: [2.6 patch] make sctp_addto_param() static
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070909202550.GX3563@stusta.de>
References: <20070909202550.GX3563@stusta.de>
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Sun, 9 Sep 2007 22:25:50 +0200

> sctp_addto_param() can become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied, thanks.
