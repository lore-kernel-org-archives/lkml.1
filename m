Return-Path: <linux-kernel-owner+w=401wt.eu-S965193AbXCBT2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965193AbXCBT2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 14:28:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965197AbXCBT2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 14:28:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52920
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965193AbXCBT2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 14:28:05 -0500
Date: Fri, 02 Mar 2007 11:28:04 -0800 (PST)
Message-Id: <20070302.112804.48527254.davem@davemloft.net>
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

For the second time, I am going to ask you very nicely to
please post this instead to the Linux networking development
mailing list, located at netdev@vger.kernel.org

That is where you will reach the most people knowledgable in
the area of your problem report, networking developers mostly
do not read linux-kernel

Thank you.
