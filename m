Return-Path: <linux-kernel-owner+w=401wt.eu-S1759547AbXKMFEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547AbXKMFEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 00:04:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750778AbXKMFEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 00:04:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48944
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750765AbXKMFEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 00:04:13 -0500
Date: Mon, 12 Nov 2007 21:04:13 -0800 (PST)
Message-Id: <20071112.210413.17069543.davem@davemloft.net>
To: bunk@kernel.org
Cc: jgarzik@pobox.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove references to net-modules.txt
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071109060141.GM26163@stusta.de>
References: <20071109060141.GM26163@stusta.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Fri, 9 Nov 2007 07:01:41 +0100

> When I removed net-modules.txt because it only contained ancient 
> information I missed that many Kconfig entries pointed to this ancient 
> information.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied, thanks Adrian.
