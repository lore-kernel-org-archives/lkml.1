Return-Path: <linux-kernel-owner+w=401wt.eu-S966240AbXDDBZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966240AbXDDBZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 21:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966239AbXDDBZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 21:25:43 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52720 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S966240AbXDDBZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 21:25:42 -0400
Date: Wed, 4 Apr 2007 02:28:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Miller <davem@davemloft.net>
Cc: dwmw2@infradead.org, flar@allandria.com, paulus@samba.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
Message-ID: <20070404022828.5c9b97f3@the-village.bc.nu>
In-Reply-To: <20070403.181645.68159458.davem@davemloft.net>
References: <1175644642.10567.31.camel@shinybook.infradead.org>
	<20070403221002.GA13210@cynthia.pants.nu>
	<1175648051.10567.61.camel@shinybook.infradead.org>
	<20070403.181645.68159458.davem@davemloft.net>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't need to know anything about the inanrds of my computer to
> bring up the ethernet interface, me caveman me bringup eth0, me on
> network, caveman happy.  The same should be true for serial ports.

You don't get machines with 64 ethernet ports on add-in cards. There are
good reasons for the naming schemes in use.

Alan
