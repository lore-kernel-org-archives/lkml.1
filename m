Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827AbZBRBX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbZBRBX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 20:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755347AbZBRBWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 20:22:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47826
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753138AbZBRBWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 20:22:05 -0500
Date: Tue, 17 Feb 2009 17:21:49 -0800 (PST)
Message-Id: <20090217.172149.196264055.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/43] drivers/net/lance.c: fix sparse warnings: fix
 signedness
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090214211257.23489.76477.stgit@vmbox.hanneseder.net>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
	<20090214211257.23489.76477.stgit@vmbox.hanneseder.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Sat, 14 Feb 2009 22:13:24 +0100

> Impact: Besides from fixing the signedness issue remove some
> whitespace to obey to the 80 character limit.
> 
> Fix this sparse warnings:
>   drivers/net/lance.c:399:19: warning: incorrect type in assignment (different signedness)
>   drivers/net/lance.c:654:29: warning: incorrect type in argument 2 (different signedness)
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Applied.
