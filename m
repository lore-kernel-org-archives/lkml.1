Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbZBRBaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbZBRBaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 20:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756283AbZBRB15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 20:27:57 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49807
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756275AbZBRB1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 20:27:55 -0500
Date: Tue, 17 Feb 2009 17:27:40 -0800 (PST)
Message-Id: <20090217.172740.194379532.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/43] drivers/net/e1000e: fix sparse warning: Should
 it be static?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090214213152.24377.68475.stgit@vmbox.hanneseder.net>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
	<20090214213152.24377.68475.stgit@vmbox.hanneseder.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Sat, 14 Feb 2009 22:32:25 +0100

> Impact: Make symbol static.
> 
> Fix this sparse warning:
>   drivers/net/e1000e/82571.c:1229:5: warning: symbol 'e1000_check_for_serdes_link_82571' was not declared. Should it be static?
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Applied.
