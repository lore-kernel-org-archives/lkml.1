Return-Path: <linux-kernel-owner+w=401wt.eu-S965935AbXIGOku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965935AbXIGOku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 10:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965424AbXIGOkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 10:40:42 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:39956 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965342AbXIGOkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 10:40:41 -0400
Date: Fri, 7 Sep 2007 16:40:39 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Folkert van Heusden <folkert@vanheusden.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: sata & scsi suggestion for make menuconfig
In-Reply-To: <20070907124800.GP16806@vanheusden.com>
Message-ID: <Pine.LNX.4.64.0709071639380.25942@fbirervta.pbzchgretzou.qr>
References: <20070907124800.GP16806@vanheusden.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 7 2007 14:48, Folkert van Heusden wrote:
>
>Maybe it is a nice enhancement for make menuconfig to more explicitly
>give a pop-up or so when someone selects for example a sata controller
>while no 'scsi-disk' support was selected?

Having no sd support is perfectly valid. Imagine a diskless boot
with only sr support.
