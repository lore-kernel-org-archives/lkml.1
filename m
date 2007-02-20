Return-Path: <linux-kernel-owner+w=401wt.eu-S932617AbXBTERN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617AbXBTERN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 23:17:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932761AbXBTERN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 23:17:13 -0500
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1234 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617AbXBTERM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 23:17:12 -0500
Message-ID: <45DA7643.4020305@xs4all.nl>
Date: Tue, 20 Feb 2007 05:17:07 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: linux-kernel@vger.kernel.org,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: PCI riser cards and PCI irq routing, etc
References: <45D85DA1.7090502@xs4all.nl>	<20070218155445.GV7584@csclub.uwaterloo.ca>	<45D87BA2.9020001@xs4all.nl>	<20070218193901.GN7582@csclub.uwaterloo.ca>	<45D9BDBF.8040405@xs4all.nl> <m3odnpq3yr.fsf@maximus.localdomain>
In-Reply-To: <m3odnpq3yr.fsf@maximus.localdomain>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Udo van den Heuvel <udovdh@xs4all.nl> writes:
> 
>> At the bottom I added a dmesg output of the kernel after boot.
>> I more or less know that irq 20 for the DVB-S card (saa7146 (1)) is
>> 'working'. I know that irq 16 for saa7146 (0) (DVB-T) is not working for
>> i2c although the card does work perfectly for DVB-T reception (picture,
>> low CPU load, etc) with only reception as the bottleneck.
> 
> BTW: Can you check which device # and IRQ does the card get if plugged
> directly into the PCI slot on board (without the riser)?

DN is 20 I believe (from the tranquilPC doc).
irq I'd have to check.

> Is it a VIA ITX board? I think I have VIA's riser card somewhere,
> could check what it does.

Yes, VIA Epia EN12000.
Interesting to check the riser card.

Udo
