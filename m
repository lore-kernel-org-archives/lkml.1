Return-Path: <linux-kernel-owner+w=401wt.eu-S1763419AbZATAHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763419AbZATAHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760323AbZATADZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 19:03:25 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49185 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758196AbZATADX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 19:03:23 -0500
Date: Tue, 20 Jan 2009 00:03:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>, teheo@novell.com,
       trenn@suse.de, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org
Subject: Re: 2.6.29-rc2: thinkpad dock -- cdrom vs. s2ram
Message-ID: <20090120000305.7895eff9@lxorguk.ukuu.org.uk>
In-Reply-To: <20090119221508.GA2576@elf.ucw.cz>
References: <20090119202423.GA7070@ucw.cz>
	<200901192150.59438.rjw@sisk.pl>
	<20090119221508.GA2576@elf.ucw.cz>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I guess I'm confused. I tried:

You want CONFIG_IDE = n, CONFIG_ATA_SFF = y, CONFIG_ATA_PIIX = y

Alan
