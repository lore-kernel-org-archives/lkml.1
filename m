Return-Path: <linux-kernel-owner+w=401wt.eu-S1751366AbXBNX2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366AbXBNX2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 18:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbXBNX2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 18:28:24 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45018 "EHLO
	localhost.localdomain" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751366AbXBNX2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 18:28:23 -0500
Date: Thu, 15 Feb 2007 00:31:41 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Dax Kelson <dax@gurulabs.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jean Delvare <khali@linux-fr.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linus' laptop and Num lock status
Message-ID: <20070215003141.72b195a4@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.61.0702142257490.19368@yvahk01.tjqt.qr>
References: <1171479361.3706.48.camel@mentorng.gurulabs.com>
	<Pine.LNX.4.64.0702141104210.3604@woody.linux-foundation.org>
	<20070214202144.1ddb930f.khali@linux-fr.org>
	<Pine.LNX.4.64.0702141130340.20368@woody.linux-foundation.org>
	<1171488840.3706.78.camel@mentorng.gurulabs.com>
	<Pine.LNX.4.61.0702142257490.19368@yvahk01.tjqt.qr>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Feb 2007 22:58:42 +0100 (MET)
Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:

> Probably just because legacy mode was enabled. Plus I wonder what 0x497 will
> return when there is actually more than one USB keyboard connected at boot.

The BIOS initial numlock value which is a singular value.

Alan
