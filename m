Return-Path: <linux-kernel-owner+w=401wt.eu-S1758387AbYBRCmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387AbYBRCmj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 21:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755443AbYBRCma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 21:42:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47228
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754688AbYBRCm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 21:42:29 -0500
Date: Sun, 17 Feb 2008 18:43:06 -0800 (PST)
Message-Id: <20080217.184306.207904047.davem@davemloft.net>
To: julia@diku.dk
Cc: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net,
       v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 7/7] net/9p/trans_virtio.c: Use BUG_ON
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0802171857310.28055@ask.diku.dk>
References: <Pine.LNX.4.64.0802171857310.28055@ask.diku.dk>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Sun, 17 Feb 2008 18:57:58 +0100 (CET)

> if (...) BUG(); should be replaced with BUG_ON(...) when the test has no
> side-effects to allow a definition of BUG_ON that drops the code completely.
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied, thanks.
