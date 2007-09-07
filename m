Return-Path: <linux-kernel-owner+w=401wt.eu-S1758058AbXIGO7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058AbXIGO7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 10:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755132AbXIGO65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 10:58:57 -0400
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1305 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814AbXIGO64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 10:58:56 -0400
Date: Fri, 7 Sep 2007 16:58:45 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sata & scsi suggestion for make menuconfig
Message-ID: <20070907145845.GQ16806@vanheusden.com>
References: <20070907124800.GP16806@vanheusden.com> <Pine.LNX.4.64.0709071639380.25942@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709071639380.25942@fbirervta.pbzchgretzou.qr>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Reply-By: Fri Sep  7 11:31:04 CEST 2007
X-Message-Flag: MultiTail - tail on steroids
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >Maybe it is a nice enhancement for make menuconfig to more explicitly
> >give a pop-up or so when someone selects for example a sata controller
> >while no 'scsi-disk' support was selected?
> 
> Having no sd support is perfectly valid. Imagine a diskless boot
> with only sr support.

Ok, but that's not the most common situaties. What I'm suggesting is a
warning or a please note popup. Not neccessarily an error or refusing to
continue thing.


Folkert van Heusden

-- 
www.vanheusden.com/multitail - win een vlaai van multivlaai! zorg
ervoor dat multitail opgenomen wordt in Fedora Core, AIX, Solaris of
HP/UX en win een vlaai naar keuze
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
