Return-Path: <linux-kernel-owner+w=401wt.eu-S1753233AbYJMEDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbYJMEDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 00:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750900AbYJMEDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 00:03:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46828
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750858AbYJMEDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 00:03:11 -0400
Date: Sun, 12 Oct 2008 21:02:47 -0700 (PDT)
Message-Id: <20081012.210247.06669920.davem@davemloft.net>
To: bunk@kernel.org
Cc: buytenh@marvell.com, jgarzik@pobox.com, ralf@linux-mips.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [2.6 patch] net/tc35815.c: fix compilation
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081012124934.GH31153@cs181140183.pp.htv.fi>
References: <20081012124934.GH31153@cs181140183.pp.htv.fi>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Sun, 12 Oct 2008 15:49:34 +0300

> Fix an obvious typo introduced by
> commit 298cf9beb9679522de995e249eccbd82f7c51999
> (phylib: move to dynamic allocation of struct mii_bus).
...
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied, thanks Adrian.
