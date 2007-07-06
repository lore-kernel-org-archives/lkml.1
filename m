Return-Path: <linux-kernel-owner+w=401wt.eu-S1762609AbXGFAHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762609AbXGFAHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 20:07:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757167AbXGFAGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 20:06:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35736
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750880AbXGFAGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 20:06:53 -0400
Date: Thu, 05 Jul 2007 17:07:13 -0700 (PDT)
Message-Id: <20070705.170713.32063175.davem@davemloft.net>
To: bunk@stusta.de
Cc: tom@opengridcomputing.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] net/core/netevent.c should #include
 <net/netevent.h>
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070705232217.GS3492@stusta.de>
References: <20070705232217.GS3492@stusta.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>
Date: Fri, 6 Jul 2007 01:22:17 +0200

> Every file should include the headers containing the prototypes for
> its global functions.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Applied, thanks Adrian.
