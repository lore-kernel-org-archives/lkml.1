Return-Path: <linux-kernel-owner+w=401wt.eu-S1753565AbYLZHzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbYLZHzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 02:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbYLZHzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 02:55:44 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37900
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751870AbYLZHzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 02:55:43 -0500
Date: Thu, 25 Dec 2008 23:55:46 -0800 (PST)
Message-Id: <20081225.235546.106485310.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/27] drivers/net: fix sparse warnings: make do-while
 a compound statement
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081222191507.11807.50794.stgit@vmbox.hanneseder.net>
References: <20081222191259.11807.53190.stgit@vmbox.hanneseder.net>
	<20081222191507.11807.50794.stgit@vmbox.hanneseder.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Mon, 22 Dec 2008 20:15:07 +0100

> While at it insert some extra curly braces and fix formatting.
...
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Applied.
