Return-Path: <linux-kernel-owner+w=401wt.eu-S1756973AbZHGDUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973AbZHGDUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 23:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755680AbZHGDUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 23:20:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55527
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751384AbZHGDUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 23:20:24 -0400
Date: Thu, 06 Aug 2009 20:20:33 -0700 (PDT)
Message-Id: <20090806.202033.232151260.davem@davemloft.net>
To: arnd@arndb.de
Cc: netdev@vger.kernel.org, kaber@trash.net, shemminger@linux-foundation.org,
       mst@redhat.com, herbert@gondor.apana.org.au, ogerlitz@voltaire.com,
       anna.fischer@hp.com, bridge@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, evb@yahoogroups.com
Subject: Re: [PATCH] macvlan: add tap device backend
From: David Miller <davem@davemloft.net>
In-Reply-To: <1249595428-21594-1-git-send-email-arnd@arndb.de>
References: <1249595428-21594-1-git-send-email-arnd@arndb.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Thu,  6 Aug 2009 21:50:28 +0000

> This is a first prototype of a new interface into the network
> stack, to eventually replace tun/tap and the bridge driver
> in certain virtual machine setups.

I don't know enough to say how good a solution this is for
the problem, but I certainly like this driver for it's
utter simplicity and minimalness.
