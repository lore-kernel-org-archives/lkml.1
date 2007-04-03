Return-Path: <linux-kernel-owner+w=401wt.eu-S1030333AbXDCPTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030333AbXDCPTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 11:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030332AbXDCPTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 11:19:52 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:36299 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030319AbXDCPTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 11:19:51 -0400
Date: Tue, 3 Apr 2007 16:19:46 +0100 (BST)
From: Christian Kujau <christian@g-house.de>
X-X-Sender: evil@sheep.housecafe.de
To: Jarek Poplawski <jarkao2@o2.pl>
cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, malte@g-house.de
Subject: Re: 2.6.20.4: NETDEV WATCHDOG and lockups
In-Reply-To: <20070403065810.GA1832@ff.dom.local>
Message-ID: <Pine.LNX.4.64.0704031618070.3963@sheep.housecafe.de>
References: <20070403065810.GA1832@ff.dom.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007, Jarek Poplawski wrote:
> Did you try with 8139cp instead of 8139too?

Tried that, 8139cp could not be loaded :(

> (Maybe even try some other card to narrow the problem?)
> You could also try to test without ehci, if it's possible.

USB has been disabled completely. After booting with 'acpi=off lapic' 
the box survived ~30min then locked up again and rebooted.

Christian.
-- 
BOFH excuse #305:

IRQ-problems with the Un-Interruptible-Power-Supply
