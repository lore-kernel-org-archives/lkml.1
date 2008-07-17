Return-Path: <linux-kernel-owner+w=401wt.eu-S1758517AbYGQHSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517AbYGQHSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbYGQHR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:17:56 -0400
Received: from eazy.amigager.de ([213.239.192.238]:59145 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692AbYGQHRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:17:55 -0400
Date: Thu, 17 Jul 2008 09:17:40 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 16
Message-ID: <20080717071739.GA17776@x61>
Mail-Followup-To: LKML <linux-kernel@vger.kernel.org>
References: <20080716235011.ac9643aa.sfr@canb.auug.org.au> <s5hmykhy9t5.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hmykhy9t5.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 20:15:50 +0200, Takashi Iwai wrote:

[...]

> On the older system, it's like
>   /dev/disk/by-id/scsi-SATA_SAMSUNG_HD160JJS0VTJ1DP401567-part6
> and now it's like
>   /dev/disk/by-id/scsi-1ATA_SAMSUNG_HD160JJS0VTJ1DP401567-part6

This is also mentioned in
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=490110, but I don't
know if the page contains a solution.

Regards,
Tino
