Return-Path: <linux-kernel-owner+w=401wt.eu-S1754435AbYLNOzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbYLNOzc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 09:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbYLNOzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 09:55:20 -0500
Received: from adsl109-3.ath.forthnet.gr ([79.103.112.3]:34894 "EHLO
	vergina.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYLNOzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 09:55:19 -0500
X-Greylist: delayed 749 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Dec 2008 09:55:18 EST
Message-ID: <49451B63.9040400@asyr.hopto.org>
Date: Sun, 14 Dec 2008 16:42:43 +0200
From: Thanasis <thanasis@asyr.hopto.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081213)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: SiI 3112 support in kernel 2.6.27
Content-Type: text/plain; charset=ISO-8859-7; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Q: In order to support the SiI 3112 (PCMCIA) controller, what module (or 
built in option) should be set for kernel version 2.6.27?

laptop linux # lspci
00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX Host 
bridge (rev 03)
00:01.0 PCI bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX AGP 
bridge (rev 03)
00:04.0 CardBus bridge: Texas Instruments PCI1420 PC card Cardbus Controller
00:04.1 CardBus bridge: Texas Instruments PCI1420 PC card Cardbus Controller
00:07.0 ISA bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 02)
00:07.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01)
00:07.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB (rev 01)
00:07.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 03)
00:08.0 Multimedia audio controller: ESS Technology ES1988 Allegro-1 
(rev 12)
00:08.1 Communication controller: ESS Technology ESS Modem (rev 12)
00:10.0 Ethernet controller: Accton Technology Corporation EN-1216 
Ethernet Adapter (rev 11)
01:01.0 VGA compatible controller: S3 Inc. 86C270-294 Savage/IX-MV (rev 13)
02:00.0 Mass storage controller: Silicon Image, Inc. SiI 3112 
[SATALink/SATARaid] Serial ATA Controller (rev 02)
laptop linux #



