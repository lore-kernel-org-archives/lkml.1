Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbZBRB2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbZBRB2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 20:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbZBRB1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 20:27:05 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54457
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755750AbZBRB1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 20:27:02 -0500
Date: Tue, 17 Feb 2009 17:26:46 -0800 (PST)
Message-Id: <20090217.172646.111747554.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/43] drivers/net/atl1e: fix sparse warnings: fix
 signedness
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090214211452.23489.8257.stgit@vmbox.hanneseder.net>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
	<20090214211452.23489.8257.stgit@vmbox.hanneseder.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Sat, 14 Feb 2009 22:14:58 +0100

> Fix this sparse warnings:
>   drivers/net/atl1e/atl1e_main.c:716:39: warning: incorrect type in argument 2 (different signedness)
>   drivers/net/atl1e/atl1e_param.c:57:1: warning: incorrect type in initializer (different signedness)
>   drivers/net/atl1e/atl1e_param.c:68:1: warning: incorrect type in initializer (different signedness)
>   drivers/net/atl1e/atl1e_param.c:81:1: warning: incorrect type in initializer (different signedness)
>   drivers/net/atl1e/atl1e_param.c:92:1: warning: incorrect type in initializer (different signedness)
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Applied.
