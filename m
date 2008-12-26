Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbYLZH7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbYLZH7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 02:59:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbYLZH7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 02:59:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37918
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753185AbYLZH7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 02:59:36 -0500
Date: Thu, 25 Dec 2008 23:59:38 -0800 (PST)
Message-Id: <20081225.235938.00539364.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/27] drivers/net/cxgb3: comment out dead code
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081222191603.11807.61006.stgit@vmbox.hanneseder.net>
References: <20081222191259.11807.53190.stgit@vmbox.hanneseder.net>
	<20081222191603.11807.61006.stgit@vmbox.hanneseder.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Mon, 22 Dec 2008 20:16:03 +0100

> The function 'vsc8211_set_speed_duplex' is not used, so comment it
> out.  For 'vsc8211_set_automdi' the function 'vsc8211_set_speed_duplex'
> is the only caller, so comment it out as well.
> 
> Fix this (sparse) warning:
 ...
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Applied.
