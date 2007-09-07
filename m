Return-Path: <linux-kernel-owner+w=401wt.eu-S1758612AbXIGTic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612AbXIGTic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 15:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758164AbXIGTiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 15:38:25 -0400
Received: from khc.piap.pl ([195.187.100.11]:50625 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbXIGTiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 15:38:24 -0400
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
Subject: Re: sata & scsi suggestion for make menuconfig
References: <20070907124800.GP16806@vanheusden.com>
	<Pine.LNX.4.64.0709071639380.25942@fbirervta.pbzchgretzou.qr>
	<20070907145845.GQ16806@vanheusden.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 07 Sep 2007 21:38:21 +0200
In-Reply-To: <20070907145845.GQ16806@vanheusden.com> (Folkert van Heusden's message of "Fri, 7 Sep 2007 16:58:45 +0200")
Message-ID: <m3myvy1d1u.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Folkert van Heusden <folkert@vanheusden.com> writes:

> Ok, but that's not the most common situaties. What I'm suggesting is a
> warning or a please note popup. Not neccessarily an error or refusing to
> continue thing.

What IMHO makes sense is changing all references to SCSI CDROM,
SCSI DISK etc. to just CDROM, DISK, and changing SCSI (menu) to
something like MASS STORAGE.
-- 
Krzysztof Halasa
