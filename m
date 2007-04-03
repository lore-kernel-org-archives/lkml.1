Return-Path: <linux-kernel-owner+w=401wt.eu-S966153AbXDCJrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966153AbXDCJrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 05:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965459AbXDCJrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 05:47:22 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:48103 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965442AbXDCJrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 05:47:21 -0400
Date: Tue, 3 Apr 2007 10:47:16 +0100 (BST)
From: Christian Kujau <christian@g-house.de>
X-X-Sender: evil@sheep.housecafe.de
To: Jarek Poplawski <jarkao2@o2.pl>
cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, malte@g-house.de
Subject: Re: 2.6.20.4: NETDEV WATCHDOG and lockups
In-Reply-To: <20070403065810.GA1832@ff.dom.local>
Message-ID: <Pine.LNX.4.64.0704031036440.3963@sheep.housecafe.de>
References: <20070403065810.GA1832@ff.dom.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007, Jarek Poplawski wrote:
> Did you try with 8139cp instead of 8139too?

I forgot about that, thanks.

> (Maybe even try some other card to narrow the problem?)

We're try to convince our hosting provider to replace the NIC with a 
e1000.

> You could also try to test without ehci, if it's possible.

Sure, I think USB is not needed.

thanks for your input!

Christian.
-- 
BOFH excuse #387:

Your computer's union contract is set to expire at midnight.
