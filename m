Return-Path: <linux-kernel-owner+w=401wt.eu-S939965AbXGaBEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939965AbXGaBEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 21:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934505AbXGaBE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 21:04:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49851
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757377AbXGaBE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 21:04:27 -0400
Date: Mon, 30 Jul 2007 18:04:20 -0700 (PDT)
Message-Id: <20070730.180420.77404858.davem@davemloft.net>
To: bunk@stusta.de
Cc: hadi@cyberus.ca, robert.olsson@its.uu.se, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [2.6 patch] make pktgen.c:get_ipsec_sa() static and non-inline
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070729145840.GY16817@stusta.de>
References: <20070729145840.GY16817@stusta.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@stusta.de>
Date: Sun, 29 Jul 2007 16:58:40 +0200

> Non-static inline code usually doesn't makes sense.
> 
> In this case making is static and non-inline is the correct solution.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Applied, thanks Adrian.
