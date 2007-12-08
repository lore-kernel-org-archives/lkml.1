Return-Path: <linux-kernel-owner+w=401wt.eu-S1756861AbXLHCHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbXLHCHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 21:07:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbXLHCH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 21:07:27 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43427
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753689AbXLHCH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 21:07:26 -0500
Date: Fri, 07 Dec 2007 18:07:26 -0800 (PST)
Message-Id: <20071207.180726.22868921.davem@davemloft.net>
To: renzo@cs.unibo.it
Cc: andi@firstfloor.org, cfriesen@nortel.com, linux-kernel@vger.kernel.org
Subject: Re: AF_IPN: Inter Process Networking, try these...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071207211804.GA8293@cs.unibo.it>
References: <20071206.224005.42816421.davem@davemloft.net>
	<20071207100322.GM20595@one.firstfloor.org>
	<20071207211804.GA8293@cs.unibo.it>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: renzo@cs.unibo.it (Renzo Davoli)
Date: Fri, 7 Dec 2007 22:18:05 +0100

> I disagree. If you suspect we would be better using IP multicast, I think
> your suspects are not supported.
> Try the following exercises, please.... Can you provide better solutions
> without IPN?

I personally have not purely advocated IP, although the performance
differences UDP and AF_UNIX should be investigated.

Instead I advocated using AF_NETLINK with some minor multicast
permission modifications to suit your needs.
