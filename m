Return-Path: <linux-kernel-owner+w=401wt.eu-S1753541AbXLDUwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbXLDUwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 15:52:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbXLDUwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 15:52:24 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:40842 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbXLDUwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 15:52:23 -0500
Message-ID: <4755BE04.8030909@garzik.org>
Date: Tue, 04 Dec 2007 15:52:20 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Chris Friesen <cfriesen@nortel.com>, linux-kernel@vger.kernel.org
Subject: Re: solid state drive access and context switching
References: <47548BF4.3010907@nortel.com> <20071203230629.725f4c7a@the-village.bc.nu>
In-Reply-To: <20071203230629.725f4c7a@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> For things like SATA based devices they aren't that fast yet. 

You forget the Gigabyte i-RAM.

For others:  the i-RAM is a SATA-based device that plugs into a PCI slot 
on your motherboard (for power), providing RAM+battery backup as fast as 
your SATA bus and DIMMs will go.

	Jeff



