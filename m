Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbZLNMim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbZLNMim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 07:38:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbZLNMil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 07:38:41 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52436
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752088AbZLNMik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 07:38:40 -0500
Date: Mon, 14 Dec 2009 04:38:41 -0800 (PST)
Message-Id: <20091214.043841.107696518.davem@davemloft.net>
To: arnd@arndb.de
Cc: herbert@gondor.apana.org.au, kaber@trash.net,
       shemminger@linux-foundation.org, mst@redhat.com, ogerlitz@voltaire.com,
       anna.fischer@hp.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       evb@yahoogroups.com
Subject: Re: [RFC] macvlan: add tap device backend
From: David Miller <davem@davemloft.net>
In-Reply-To: <200912141300.37063.arnd@arndb.de>
References: <1259862720-28432-3-git-send-email-arnd@arndb.de>
	<20091212084112.GA8948@gondor.apana.org.au>
	<200912141300.37063.arnd@arndb.de>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 14 Dec 2009 13:00:36 +0100

> c) prepare a combined patch for net-next.git, or

This is probably fine.

I'll be taking patches into net-next-2.6 right after Linus
releases 2.6.33-rc1.
