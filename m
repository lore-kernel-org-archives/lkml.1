Return-Path: <linux-kernel-owner+w=401wt.eu-S1752526AbXHBEys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbXHBEys (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 00:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbXHBEyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 00:54:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41570
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751779AbXHBEyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 00:54:35 -0400
Date: Wed, 01 Aug 2007 21:54:35 -0700 (PDT)
Message-Id: <20070801.215435.103776209.davem@davemloft.net>
To: m.kozlowski@tuxland.pl
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH 67] net/ipv4/route.c: mostly kmalloc + memset
 conversion to k[cz]alloc
From: David Miller <davem@davemloft.net>
In-Reply-To: <200707312355.03321.m.kozlowski@tuxland.pl>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
	<200707312355.03321.m.kozlowski@tuxland.pl>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Date: Tue, 31 Jul 2007 23:55:02 +0200

> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Applied.
