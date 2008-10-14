Return-Path: <linux-kernel-owner+w=401wt.eu-S1757586AbYJNBsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586AbYJNBsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 21:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754908AbYJNBsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 21:48:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56531
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754851AbYJNBsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 21:48:41 -0400
Date: Mon, 13 Oct 2008 18:48:17 -0700 (PDT)
Message-Id: <20081013.184817.87272235.davem@davemloft.net>
To: bunk@kernel.org
Cc: buytenh@marvell.com, afleming@freescale.com, jgarzik@pobox.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [2.6 patch] export genphy_restart_aneg
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081013171900.GK29938@cs181140183.pp.htv.fi>
References: <20081013171900.GK29938@cs181140183.pp.htv.fi>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Mon, 13 Oct 2008 20:19:00 +0300

> This patch fixes the following build error caused by
> commit ed94493fb38a665cebcf750dfabe8a6dd13e136f
> (mv643xx_eth: convert to phylib):

Applied, th anks Adrian.
