Return-Path: <linux-kernel-owner+w=401wt.eu-S1756312AbZBRBYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbZBRBYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 20:24:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755403AbZBRBWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 20:22:23 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47832
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753675AbZBRBWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 20:22:21 -0500
Date: Tue, 17 Feb 2009 17:22:06 -0800 (PST)
Message-Id: <20090217.172206.07506142.davem@davemloft.net>
To: gorcunov@gmail.com
Cc: hannes@hanneseder.net, netdev@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/43] drivers/net/ppp*.c: fix sparse warnings: fix
 signedness
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090214212948.GE7648@localhost>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
	<20090214211346.23489.96321.stgit@vmbox.hanneseder.net>
	<20090214212948.GE7648@localhost>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>
Date: Sun, 15 Feb 2009 00:29:48 +0300

> [Hannes Eder - Sat, Feb 14, 2009 at 10:13:52PM +0100]
> | Fix this sparse warnings:
> |   drivers/net/ppp_generic.c:919:43: warning: incorrect type in argument 1 (different signedness)
> |   drivers/net/pppoe.c:1195:43: warning: incorrect type in argument 1 (different signedness)
> |   drivers/net/pppol2tp.c:2666:43: warning: incorrect type in argument 1 (different signedness)
> | 
> | Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> ...
> 
> Thanks Hannes,
> 
> Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>

Applied.
