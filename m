Return-Path: <linux-kernel-owner+w=401wt.eu-S1753418AbYLZCFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbYLZCFB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 21:05:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbYLZCEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 21:04:16 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34503
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753145AbYLZCEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 21:04:13 -0500
Date: Thu, 25 Dec 2008 18:04:16 -0800 (PST)
Message-Id: <20081225.180416.113146112.davem@davemloft.net>
To: julia@diku.dk
Cc: khc@pm.waw.pl, jgarzik@pobox.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 7/13] drivers/net/wan: Remove redundant test
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0812211638550.9555@pc-004.diku.dk>
References: <Pine.LNX.4.64.0812211638550.9555@pc-004.diku.dk>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Sun, 21 Dec 2008 16:39:15 +0100 (CET)

> arg is checked not to be NULL a few lines before.

Applied.
