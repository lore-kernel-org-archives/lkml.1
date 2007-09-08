Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbXIHWyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbXIHWyl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 18:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbXIHWye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 18:54:34 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:38316 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798AbXIHWyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 18:54:33 -0400
Date: Sun, 9 Sep 2007 00:54:32 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: development.jim@gmail.com
cc: linux-kernel@vger.kernel.org
Subject: Re: USB and MMC device problems on Kernel 2.6.22
In-Reply-To: <46E32207.6080104@gmail.com>
Message-ID: <Pine.LNX.4.64.0709090053450.8346@fbirervta.pbzchgretzou.qr>
References: <46E32207.6080104@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 9 2007 08:28, development.jim@gmail.com wrote:
>
> I have an ARM hardware board works fine with USB and MMC on kernel
> 2.6.11. Now, I've just upgraded it to kernel 2.6.22. The modules
> seem loaded fine, please see following list, but neither USB nor
> MMC could detect devices when a USB stick or SD card was plugged in

If it detects something, it should show up in `lsusb`.
