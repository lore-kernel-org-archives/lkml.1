Return-Path: <linux-kernel-owner+w=401wt.eu-S932624AbXBSUhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624AbXBSUhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 15:37:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932611AbXBSUhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 15:37:06 -0500
Received: from khc.piap.pl ([195.187.100.11]:51677 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932609AbXBSUhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 15:37:04 -0500
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: linux-kernel@vger.kernel.org,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: PCI riser cards and PCI irq routing, etc
References: <45D85DA1.7090502@xs4all.nl>
	<20070218155445.GV7584@csclub.uwaterloo.ca>
	<45D87BA2.9020001@xs4all.nl>
	<20070218193901.GN7582@csclub.uwaterloo.ca>
	<45D9BDBF.8040405@xs4all.nl>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 19 Feb 2007 21:37:00 +0100
In-Reply-To: <45D9BDBF.8040405@xs4all.nl> (Udo van den Heuvel's message of "Mon, 19 Feb 2007 16:09:51 +0100")
Message-ID: <m3odnpq3yr.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Udo van den Heuvel <udovdh@xs4all.nl> writes:

> At the bottom I added a dmesg output of the kernel after boot.
> I more or less know that irq 20 for the DVB-S card (saa7146 (1)) is
> 'working'. I know that irq 16 for saa7146 (0) (DVB-T) is not working for
> i2c although the card does work perfectly for DVB-T reception (picture,
> low CPU load, etc) with only reception as the bottleneck.

BTW: Can you check which device # and IRQ does the card get if plugged
directly into the PCI slot on board (without the riser)?

Is it a VIA ITX board? I think I have VIA's riser card somewhere,
could check what it does.
-- 
Krzysztof Halasa
