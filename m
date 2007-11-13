Return-Path: <linux-kernel-owner+w=401wt.eu-S1760874AbXKMFZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760874AbXKMFZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 00:25:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760814AbXKMFZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 00:25:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33416
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760803AbXKMFZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 00:25:12 -0500
Date: Mon, 12 Nov 2007 21:25:11 -0800 (PST)
Message-Id: <20071112.212511.109029415.davem@davemloft.net>
To: bunk@kernel.org
Cc: rumen@voicecho.com, wensong@linux-vs.org, horms@verge.net.au, ja@ssi.bg,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] net/ipv4/ipvs/: remove unused exports
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071111064840.GJ21669@stusta.de>
References: <20071111064840.GJ21669@stusta.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Sun, 11 Nov 2007 07:48:40 +0100

> This patch removes the following unused EXPORT_SYMBOL's:
> - ip_vs_try_bind_dest
> - ip_vs_find_dest
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied.
