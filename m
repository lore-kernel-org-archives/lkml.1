Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbYLZILh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbYLZILh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 03:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbYLZIL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 03:11:26 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53370
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750752AbYLZILZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 03:11:25 -0500
Date: Fri, 26 Dec 2008 00:11:27 -0800 (PST)
Message-Id: <20081226.001127.216496763.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 21/27] drivers/net/wan: fix sparse warning: make symbol
 static
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081222191804.11807.55143.stgit@vmbox.hanneseder.net>
References: <20081222191259.11807.53190.stgit@vmbox.hanneseder.net>
	<20081222191804.11807.55143.stgit@vmbox.hanneseder.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Mon, 22 Dec 2008 20:18:04 +0100

> Fix this sparse warning:
> 
>   drivers/net/wan/x25_asy.c:623:5: warning: symbol 'x25_asy_esc' was not declared. Should it be static?
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Applied.
