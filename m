Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbYJMEDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbYJMEDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 00:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754489AbYJMEDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 00:03:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46836
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750900AbYJMEDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 00:03:30 -0400
Date: Sun, 12 Oct 2008 21:03:06 -0700 (PDT)
Message-Id: <20081012.210306.222286255.davem@davemloft.net>
To: bunk@kernel.org
Cc: buytenh@marvell.com, jgarzik@pobox.com, ralf@linux-mips.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [2.6 patch] net/au1000_eth.c MDIO namespace fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081012124939.GI31153@cs181140183.pp.htv.fi>
References: <20081012124939.GI31153@cs181140183.pp.htv.fi>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Sun, 12 Oct 2008 15:49:39 +0300

> Commit 2e888103295f47b8fcbf7e9bb8c5da97dd2ecd76
> (phylib: add mdiobus_{read,write}) causes the
> following compile error:
 ...
> This patch prefixes the driver functions with au1000_ 
> 
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Also applied, thanks a lot.
