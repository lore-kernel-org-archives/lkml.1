Return-Path: <linux-kernel-owner+w=401wt.eu-S1752621AbXBEAnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbXBEAnX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 19:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbXBEAnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 19:43:23 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37424
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752619AbXBEAnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 19:43:22 -0500
Date: Sun, 04 Feb 2007 16:43:21 -0800 (PST)
Message-Id: <20070204.164321.32065834.davem@davemloft.net>
To: ahendry@tusc.com.au
Cc: linux-x25@vger.kernel.org, eis@baty.hanse.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.19 2/2] X.25: Adds /proc/net/x25/forward to view
 active forwarded calls.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1167881835.5124.89.camel@localhost>
References: <1167881835.5124.89.camel@localhost>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: ahendry <ahendry@tusc.com.au>
Date: Thu, 04 Jan 2007 14:37:15 +1100

> View the active forwarded call list
> cat /proc/net/x25/forward
> 
> Signed-off-by: Andrew Hendry <andrew.hendry@gmail.com>

Applied, thanks a lot.
