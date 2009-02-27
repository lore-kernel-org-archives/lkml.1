Return-Path: <linux-kernel-owner+w=401wt.eu-S1759466AbZB0HOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466AbZB0HOY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 02:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756641AbZB0HOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 02:14:10 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42489
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754923AbZB0HOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 02:14:09 -0500
Date: Thu, 26 Feb 2009 23:13:53 -0800 (PST)
Message-Id: <20090226.231353.238232825.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] net: fix (sparse) warnings
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090225203012.6251.32002.stgit@vmbox.hanneseder.net>
References: <20090225203012.6251.32002.stgit@vmbox.hanneseder.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Wed, 25 Feb 2009 21:31:10 +0100

> The following series fixes some (sparse) warnings in net/.
> 
> ---
> 
> Hannes Eder (8):
>       wanrouter: fix sparse warnings: context imbalance
>       inet fragments: fix sparse warning: context imbalance
>       decnet: fix sparse warnings: symbol shadows an earlier one
>       decnet: fix sparse warnings: context imbalance
>       [NET] sysctl: fix sparse warning: Should it be static?
>       appletalk: fix warning: format not a string literal and no ...
>       9p: fix sparse warning: cast adds address space
>       net/802: fix sparse warnings: context imbalance

All applied to net-next-2.6, thanks!
