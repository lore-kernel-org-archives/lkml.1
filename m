Return-Path: <linux-kernel-owner+w=401wt.eu-S1752711AbYLZCEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbYLZCEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 21:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbYLZCEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 21:04:00 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34495
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752845AbYLZCD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 21:03:59 -0500
Date: Thu, 25 Dec 2008 18:04:01 -0800 (PST)
Message-Id: <20081225.180401.17507583.davem@davemloft.net>
To: julia@diku.dk
Cc: jgarzik@pobox.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 5/13] drivers/net/ehea: Remove redundant test
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0812211637370.9555@pc-004.diku.dk>
References: <Pine.LNX.4.64.0812211637370.9555@pc-004.diku.dk>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Sun, 21 Dec 2008 16:37:55 +0100 (CET)

> In each case, vpage is checked not to be NULL just after it is initialized
> at the beginning of each loop iteration.

Applied.
