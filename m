Return-Path: <linux-kernel-owner+w=401wt.eu-S1756272AbZB0JDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbZB0JDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 04:03:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756516AbZB0JBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 04:01:48 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46250
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754387AbZB0JBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 04:01:45 -0500
Date: Fri, 27 Feb 2009 01:01:29 -0800 (PST)
Message-Id: <20090227.010129.221180189.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] drivers/isdn: fix sparse warnings
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090225230737.5377.31370.stgit@localhost.localdomain>
References: <20090225230737.5377.31370.stgit@localhost.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Thu, 26 Feb 2009 00:08:20 +0100

> The following series fixes some sparse warnings in drivers/isdn.
> 
> ---
> 
> Hannes Eder (5):
>       drivers/isdn/hardware/eicon: fix sparse warnings: Should it be static?
>       drivers/isdn/hardware/icon: fix sparse warning: cast truncates bits
>       drivers/isdn/hisax: fix sparse warning: Should it be static?
>       drivers/isdn/act2000: fix sparse warning: symbol shadows an earlier one
>       drivers/isdn/capi: fix sparse warning: context imbalance

Applied to net-next-2.6, thanks!
