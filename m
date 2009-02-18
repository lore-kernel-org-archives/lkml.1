Return-Path: <linux-kernel-owner+w=401wt.eu-S1755836AbZBRDh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbZBRDh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 22:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbZBRDfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 22:35:43 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59008
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754469AbZBRDfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 22:35:40 -0500
Date: Tue, 17 Feb 2009 19:35:24 -0800 (PST)
Message-Id: <20090217.193524.111535677.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 36/43] drivers/net/wan: fix sparse warning: symbol
 shadows an earlier one
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090214214815.24377.92862.stgit@vmbox.hanneseder.net>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
	<20090214214815.24377.92862.stgit@vmbox.hanneseder.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Sat, 14 Feb 2009 22:48:25 +0100

> Impact: Rename function scope variable and while being at it fix some
> coding style issues.
> 
> Fix this sparse warning:
>   drivers/net/wan/sbni.c:1526:14: warning: symbol 'num' shadows an earlier one
>   drivers/net/wan/sbni.c:160:13: originally declared here
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Applied.
