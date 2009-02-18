Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbZBRB3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbZBRB3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 20:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbZBRB1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 20:27:25 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54466
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756077AbZBRB1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 20:27:22 -0500
Date: Tue, 17 Feb 2009 17:27:06 -0800 (PST)
Message-Id: <20090217.172706.62227876.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/43] drivers/net/bonding: fix sparse warning: symbol
 shadows an earlier one
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090214211541.23489.33717.stgit@vmbox.hanneseder.net>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
	<20090214211541.23489.33717.stgit@vmbox.hanneseder.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Sat, 14 Feb 2009 22:15:49 +0100

> Impact: Rename function scope variable.
> 
> Fix this sparse warning:
>   drivers/net/bonding/bond_main.c:4704:13: warning: symbol 'mode' shadows an earlier one
>   drivers/net/bonding/bond_main.c:95:13: originally declared here
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Applied.
