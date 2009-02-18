Return-Path: <linux-kernel-owner+w=401wt.eu-S1755961AbZBRDui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbZBRDui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 22:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbZBRDt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 22:49:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55691
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754189AbZBRDty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 22:49:54 -0500
Date: Tue, 17 Feb 2009 19:49:39 -0800 (PST)
Message-Id: <20090217.194939.168796459.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 42/43] drivers/net/wireless/ipw2x00: fix sparse
 warnings: fix signedness
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090214215013.24377.69151.stgit@vmbox.hanneseder.net>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
	<20090214215013.24377.69151.stgit@vmbox.hanneseder.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Sat, 14 Feb 2009 22:50:26 +0100

> Fix this sparse warnings:
>   drivers/net/wireless/ipw2x00/ipw2100.c:1930:43: warning: incorrect type in argument 4 (different signedness)
>   drivers/net/wireless/ipw2x00/ipw2100.c:1938:76: warning: incorrect type in argument 4 (different signedness)
>   drivers/net/wireless/ipw2x00/ipw2100.c:1946:67: warning: incorrect type in argument 4 (different signedness)
>   drivers/net/wireless/ipw2x00/ipw2100.c:1953:72: warning: incorrect type in argument 4 (different signedness)
>   drivers/net/wireless/ipw2x00/ipw2100.c:4071:73: warning: incorrect type in argument 4 (different signedness)
>   drivers/net/wireless/ipw2x00/ipw2100.c:4078:43: warning: incorrect type in argument 4 (different signedness)
>   drivers/net/wireless/ipw2x00/ipw2100.c:4084:67: warning: incorrect type in argument 4 (different signedness)
>   drivers/net/wireless/ipw2x00/ipw2100.c:7141:73: warning: incorrect type in argument 4 (different signedness)
>   drivers/net/wireless/ipw2x00/ipw2100.c:8317:48: warning: incorrect type in argument 4 (different signedness)
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Applied.
