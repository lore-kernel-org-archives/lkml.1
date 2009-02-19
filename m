Return-Path: <linux-kernel-owner+w=401wt.eu-S1753562AbZBSDgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbZBSDgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 22:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbZBSDg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 22:36:27 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34814
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752493AbZBSDg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 22:36:26 -0500
Date: Wed, 18 Feb 2009 19:36:11 -0800 (PST)
Message-Id: <20090218.193611.177113978.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 23/43 v2] drivers/net/igb: fix sparse warning: symbol
 shadows an earlier one
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090218214705.8438.48732.stgit@vmbox.hanneseder.net>
References: <20090217.173903.121180042.davem@davemloft.net>
	<20090218214705.8438.48732.stgit@vmbox.hanneseder.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Wed, 18 Feb 2009 22:49:20 +0100

> Impact: Move variable declaration as far inner as possible.
> 
> Fix this sparse warning:
>   drivers/net/igb/igb_main.c:1895:21: warning: symbol 'j' shadows an earlier one
>   drivers/net/igb/igb_main.c:1855:16: originally declared here
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Applied, thanks.
