Return-Path: <linux-kernel-owner+w=401wt.eu-S1754987AbXHBEw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbXHBEw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 00:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbXHBEwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 00:52:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41554
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751847AbXHBEwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 00:52:49 -0400
Date: Wed, 01 Aug 2007 21:52:49 -0700 (PDT)
Message-Id: <20070801.215249.98749537.davem@davemloft.net>
To: m.kozlowski@tuxland.pl
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       netfilter-devel@lists.netfilter.org, kernel-janitors@vger.kernel.org,
       coreteam@netfilter.org
Subject: Re: [PATCH 57] net/netfilter/nf_conntrack_expect.c: kmalloc +
 memset conversion to kzalloc
From: David Miller <davem@davemloft.net>
In-Reply-To: <200707312331.02887.m.kozlowski@tuxland.pl>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
	<200707312331.02887.m.kozlowski@tuxland.pl>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Date: Tue, 31 Jul 2007 23:31:02 +0200

> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Applied.
