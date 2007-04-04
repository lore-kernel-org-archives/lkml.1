Return-Path: <linux-kernel-owner+w=401wt.eu-S966272AbXDDBsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966272AbXDDBsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 21:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966271AbXDDBsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 21:48:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50177
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S966268AbXDDBsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 21:48:04 -0400
Date: Tue, 03 Apr 2007 18:48:04 -0700 (PDT)
Message-Id: <20070403.184804.35358780.davem@davemloft.net>
To: david.lang@digitalinsight.com
Cc: alan@lxorguk.ukuu.org.uk, dwmw2@infradead.org, flar@allandria.com,
       paulus@samba.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.63.0704031804350.21680@qynat.qvtvafvgr.pbz>
References: <20070403.181645.68159458.davem@davemloft.net>
	<20070404022828.5c9b97f3@the-village.bc.nu>
	<Pine.LNX.4.63.0704031804350.21680@qynat.qvtvafvgr.pbz>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Lang <david.lang@digitalinsight.com>
Date: Tue, 3 Apr 2007 18:07:06 -0700 (PDT)

> I've seen machines offering up to 48, what's the magic number that makes you 
> need to chagne nameing schemes?

Yep, excellent point.
