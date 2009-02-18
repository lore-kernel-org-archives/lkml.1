Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbZBRBXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbZBRBXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 20:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755027AbZBRBV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 20:21:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47820
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754941AbZBRBVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 20:21:55 -0500
Date: Tue, 17 Feb 2009 17:21:39 -0800 (PST)
Message-Id: <20090217.172139.210351923.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/43] drivers/net/ns83820.c: fix sparse warnings: fix
 signedness
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090214211231.23489.52423.stgit@vmbox.hanneseder.net>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
	<20090214211231.23489.52423.stgit@vmbox.hanneseder.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Sat, 14 Feb 2009 22:12:36 +0100

> Fix this sparse warnings:
>   drivers/net/ns83820.c:479:36: warning: incorrect type in argument 2 (different signedness)
>   drivers/net/ns83820.c:479:36: warning: incorrect type in argument 2 (different signedness)
>   drivers/net/ns83820.c:479:36: warning: incorrect type in argument 2 (different signedness)
>   drivers/net/ns83820.c:479:36: warning: incorrect type in argument 2 (different signedness)
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Applied.
