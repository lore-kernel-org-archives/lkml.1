Return-Path: <linux-kernel-owner+w=401wt.eu-S936346AbXLQWl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936346AbXLQWl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 17:41:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758491AbXLQWlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 17:41:17 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48244
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757335AbXLQWlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 17:41:16 -0500
Date: Mon, 17 Dec 2007 14:41:15 -0800 (PST)
Message-Id: <20071217.144115.206059122.davem@davemloft.net>
To: jengelh@computergmbh.de
Cc: joe@perches.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-2.6.25 1/8] Create ipv4_is_<type>(__be32 addr)
 functions
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0712172333550.32270@fbirervta.pbzchgretzou.qr>
References: <1197589141-7020-1-git-send-email-joe@perches.com>
	<Pine.LNX.4.64.0712172333550.32270@fbirervta.pbzchgretzou.qr>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Engelhardt <jengelh@computergmbh.de>
Date: Mon, 17 Dec 2007 23:37:24 +0100 (CET)

> Can we use __constant_htonl()?

That should only be used in initializers.
