Return-Path: <linux-kernel-owner+w=401wt.eu-S1751867AbZDPDnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbZDPDnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 23:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbZDPDnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 23:43:00 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51664 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbZDPDm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 23:42:59 -0400
Message-ID: <49E6A937.706@garzik.org>
Date: Wed, 15 Apr 2009 23:42:47 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Mark Lord <lkml@rtr.ca>, Greg KH <greg@kroah.com>,
       Linux USB kernel mailing list <linux-usb@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: USB storage no-boot regression (bisected)
References: <49E4FAC6.1030400@garzik.org>	<20090415014930.GA29413@kroah.com>	<49E5480F.10501@garzik.org>	<20090415050947.GB3462@kroah.com>	<49E5EE41.3090505@rtr.ca>	<20090415073001.503b0361@infradead.org>	<49E5FF48.3030809@rtr.ca>	<20090415125813.34c9a151@infradead.org>	<49E657BC.6000707@rtr.ca> <20090415183213.7962d929@infradead.org>
In-Reply-To: <20090415183213.7962d929@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> .... who would boot their server from a USB stick for production use?

Whole distros have chosen to do so.  the real world doesn't care about 
USB enumeration details, they just want to boot off their $9 Wal-Mart 
USB sticks... :)

	Jeff



