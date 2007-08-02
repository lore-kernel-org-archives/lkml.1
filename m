Return-Path: <linux-kernel-owner+w=401wt.eu-S1753556AbXHBExn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbXHBExn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 00:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbXHBExf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 00:53:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41561
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751528AbXHBExe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 00:53:34 -0400
Date: Wed, 01 Aug 2007 21:53:35 -0700 (PDT)
Message-Id: <20070801.215335.112852785.davem@davemloft.net>
To: m.kozlowski@tuxland.pl
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       akpm@linux-foundation.org, netfilter-devel@lists.netfilter.org,
       coreteam@netfilter.org
Subject: Re: [PATCH 58]
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c: kmalloc + memset
 conversion to kzalloc
From: David Miller <davem@davemloft.net>
In-Reply-To: <200707312332.05176.m.kozlowski@tuxland.pl>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
	<200707312332.05176.m.kozlowski@tuxland.pl>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Date: Tue, 31 Jul 2007 23:32:04 +0200

> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Applied.
