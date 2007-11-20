Return-Path: <linux-kernel-owner+w=401wt.eu-S1758870AbXKTGu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870AbXKTGu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 01:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756280AbXKTGuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 01:50:50 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40577
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752557AbXKTGut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 01:50:49 -0500
Date: Mon, 19 Nov 2007 22:50:48 -0800 (PST)
Message-Id: <20071119.225048.111848671.davem@davemloft.net>
To: julia@diku.dk
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/5] arch/sparc64: Add missing pci_dev_put
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0711190901330.19198@ask.diku.dk>
References: <Pine.LNX.4.64.0711190901330.19198@ask.diku.dk>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Mon, 19 Nov 2007 09:02:22 +0100 (CET)

> From: Julia Lawall <julia@diku.dk>
> 
> There should be a pci_dev_put when breaking out of a loop that iterates
> over calls to pci_get_device and similar functions.
 ..
> Signed-off-by: Julia Lawall <julia@diku.dk>

Patch applied, but something in your email client adds
extra spaces to the second column of several lines in your
your patch.

Please correct this before making future patch submissions.

Thank you.
