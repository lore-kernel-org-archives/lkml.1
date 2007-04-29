Return-Path: <linux-kernel-owner+w=401wt.eu-S1756347AbXD2K4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347AbXD2K4y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 06:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbXD2K4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 06:56:30 -0400
Received: from mail.suse.de ([195.135.220.2]:52757 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756347AbXD2K4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:56:18 -0400
To: Syren Baran <sbaran@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Probable PCIE prob
References: <1177790017.3649.23.camel@excalibur>
From: Andi Kleen <andi@firstfloor.org>
Date: 29 Apr 2007 13:54:02 +0200
In-Reply-To: <1177790017.3649.23.camel@excalibur>
Message-ID: <p73hcqz1jmt.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Syren Baran <sbaran@gmx.de> writes:

> i got a problem with the combination of an Asrock AM2NF4G-SATA2
> mainboard with a Radeon X1900 (chip 1002,724b) graphics
> card. /i386/pci/mmconfig.c reports a buggy bios (e0000000 is not
> E820-reserved).

This message is harmless and likely unrelated.

 System crashes only happen when viewing films (neither
> xine nor mplayer run with root privileges) and independent of video
> drivers (framebuffer, vesa and fglrx). Logs dont show any anomalies
> before crashing. Anybody got a clue?

Sounds like some sort of hardware problem. Maybe the power supply
is not up to the task? Or the board could be broken. Also always
worth updating the BIOS.

-Andi
