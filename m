Return-Path: <linux-kernel-owner+w=401wt.eu-S1758240AbYBRCl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240AbYBRCl5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 21:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbYBRClu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 21:41:50 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47220
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753635AbYBRClt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 21:41:49 -0500
Date: Sun, 17 Feb 2008 18:42:22 -0800 (PST)
Message-Id: <20080217.184222.129385804.davem@davemloft.net>
To: julia@diku.dk
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 5/7] net/rxrpc: Use BUG_ON
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0802171856240.28055@ask.diku.dk>
References: <Pine.LNX.4.64.0802171856240.28055@ask.diku.dk>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Sun, 17 Feb 2008 18:56:52 +0100 (CET)

> if (...) BUG(); should be replaced with BUG_ON(...) when the test has no
> side-effects to allow a definition of BUG_ON that drops the code completely.
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied, thanks.
