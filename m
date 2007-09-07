Return-Path: <linux-kernel-owner+w=401wt.eu-S1751876AbXIGXDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbXIGXDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 19:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750951AbXIGXC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 19:02:56 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:51456 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbXIGXCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 19:02:55 -0400
Date: Sat, 8 Sep 2007 01:02:54 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Krzysztof Halasa <khc@pm.waw.pl>
cc: Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org
Subject: Re: sata & scsi suggestion for make menuconfig
In-Reply-To: <m3myvy1d1u.fsf@maximus.localdomain>
Message-ID: <Pine.LNX.4.64.0709080101471.25942@fbirervta.pbzchgretzou.qr>
References: <20070907124800.GP16806@vanheusden.com>
 <Pine.LNX.4.64.0709071639380.25942@fbirervta.pbzchgretzou.qr>
 <20070907145845.GQ16806@vanheusden.com> <m3myvy1d1u.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 7 2007 21:38, Krzysztof Halasa wrote:
>> Ok, but that's not the most common situaties. What I'm suggesting is a
>> warning or a please note popup. Not neccessarily an error or refusing to
>> continue thing.
>
>What IMHO makes sense is changing all references to SCSI CDROM,
>SCSI DISK etc. to just CDROM, DISK, and changing SCSI (menu) to
>something like MASS STORAGE.

There is still too much SCSI in it IMO :-)
