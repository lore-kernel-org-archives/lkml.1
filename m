Return-Path: <linux-kernel-owner+w=401wt.eu-S965485AbXCASfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965485AbXCASfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 13:35:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965496AbXCASfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 13:35:38 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44275
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965485AbXCASfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 13:35:34 -0500
Date: Thu, 01 Mar 2007 10:35:32 -0800 (PST)
Message-Id: <20070301.103532.130237452.davem@davemloft.net>
To: grzegorz.nosek@netart.pl
Cc: linux-kernel@vger.kernel.org
Subject: Re: Very slow routing table modification if RTA_FLOW is set
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070301142911.GA8187@tech.serwery.pl>
References: <20070301142911.GA8187@tech.serwery.pl>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: NetArt - Grzegorz Nosek <grzegorz.nosek@netart.pl>
Date: Thu, 1 Mar 2007 15:29:11 +0100

> I have noticed that using realm patch for quagga
> <http://vcalinus.gemenii.ro/quaggarealms.html> causes the kernel to
> spend a lot more time processing rtnetlink messages.

Please report networking problems to the networking development
list which is netdev@vger.kernel.org, thank you.

Most networking developers do not read linux-kernel.
