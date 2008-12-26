Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbYLZIJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbYLZIJM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 03:09:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbYLZIIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 03:08:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54379
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750747AbYLZIIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 03:08:54 -0500
Date: Fri, 26 Dec 2008 00:08:56 -0800 (PST)
Message-Id: <20081226.000856.244642118.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/27] drivers/net/usb: fix sparse warnings: make
 symbols static
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081222191745.11807.75548.stgit@vmbox.hanneseder.net>
References: <20081222191259.11807.53190.stgit@vmbox.hanneseder.net>
	<20081222191745.11807.75548.stgit@vmbox.hanneseder.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Mon, 22 Dec 2008 20:17:46 +0100

> Fix this sparse warnings:
 ...
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

There have been changes in this area in the net-next-2.6 tree
so this patch won't apply.

Please regenerate this after I am able to merge all of my
networking bits to Linus for the 2.6.29 merge window.

Thanks.
