Return-Path: <linux-kernel-owner+w=401wt.eu-S1751153Ab0A2Fde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751153Ab0A2Fde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 00:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017Ab0A2Fdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 00:33:33 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55104
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750950Ab0A2Fdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 00:33:32 -0500
Date: Thu, 28 Jan 2010 21:33:44 -0800 (PST)
Message-Id: <20100128.213344.226776729.davem@davemloft.net>
To: arnd@arndb.de
Cc: shemminger@linux-foundation.org, kaber@trash.net, mst@redhat.com,
       herbert@gondor.apana.org.au, ogerlitz@voltaire.com,
       netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] net: maintain namespace isolation between vlan and
 real device
From: David Miller <davem@davemloft.net>
In-Reply-To: <201001271105.15733.arnd@arndb.de>
References: <201001271104.20607.arnd@arndb.de>
	<201001271105.15733.arnd@arndb.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 27 Jan 2010 11:05:15 +0100

> + * skb_dev_set -- assign a buffer to a new device

My english is terrible, but I think this should be
"assign a new device to a buffer".

If you agree, please fix this up when you resubmit patches #1 and #2
along with the fix you already plan to make to patch #3.

Thanks!
