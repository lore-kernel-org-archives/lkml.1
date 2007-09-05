Return-Path: <linux-kernel-owner+w=401wt.eu-S1756519AbXIEPVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbXIEPVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 11:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932151AbXIEPUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 11:20:47 -0400
Received: from 74-93-104-98-Washington.hfc.comcastbusiness.net ([74.93.104.98]:54314
	"EHLO picasso.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752137AbXIEPUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 11:20:46 -0400
X-Greylist: delayed 1401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Sep 2007 11:20:46 EDT
Date: Wed, 05 Sep 2007 07:57:23 -0700 (PDT)
Message-Id: <20070905.075723.104052614.davem@davemloft.net>
To: micah.gruber@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Remove unneeded pointer iph from ipcomp6_input() in
 net/ipv6/ipcomp6.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <46DE4248.6070604@gmail.com>
References: <46DE4248.6070604@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micah Gruber <micah.gruber@gmail.com>
Date: Wed, 05 Sep 2007 13:44:40 +0800

> This trivial patch removes the unneeded pointer iph, which is never used.
> 
> Signed-off-by: Micah Gruber < micah.gruber@gmail.com>

Applied, thanks.
