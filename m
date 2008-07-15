Return-Path: <linux-kernel-owner+w=401wt.eu-S1761145AbYGOQEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761145AbYGOQEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 12:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754560AbYGOQEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 12:04:30 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:47916 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbYGOQE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 12:04:29 -0400
Date: Tue, 15 Jul 2008 12:03:35 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: so ... what's really and truly "obsolete" and can be tossed?
Message-ID: <alpine.LFD.1.10.0807151202280.3861@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


$ grep -wi obsolete $(find . -name Kconfig*)
./drivers/isdn/Kconfig:	  Therefore the old ISDN4Linux layer will eventually become obsolete.
./drivers/message/i2o/Kconfig:	bool "Enable ioctls (OBSOLETE)"
./drivers/sbus/char/Kconfig:	tristate "Bidirectional parallel port support (OBSOLETE)"
./drivers/sbus/char/Kconfig:	  Say Y here to support Sun's obsolete variant of IEEE1284
./drivers/mtd/nand/Kconfig:	bool "Enable chip ids for obsolete ancient NAND devices"
./drivers/net/Kconfig:	  new card, since the 3c501 is slow, broken, and obsolete: you will
./drivers/block/paride/Kconfig:	  This option enables support for the (obsolete) EPIA parallel port
./drivers/block/paride/Kconfig:	  This option enables support for the (obsolete) 90c20 parallel port
./drivers/block/Kconfig:	  obsolete. For details, read <file:Documentation/ramdisk.txt>.
./drivers/misc/Kconfig:	  This support was made obsolete by the generic ACPI docking station
./drivers/pcmcia/Kconfig:	bool "PCMCIA control ioctl (obsolete)"
./net/bridge/netfilter/Kconfig:	tristate "ebt: ulog support (OBSOLETE)"
./net/netfilter/Kconfig:	  This target replaced the old obsolete QUEUE target.
./net/ipv6/netfilter/Kconfig:	tristate "IP6 Userspace queueing via NETLINK (OBSOLETE)"
./net/ipv4/netfilter/Kconfig:	tristate "IP Userspace queueing via NETLINK (OBSOLETE)"
./net/ipv4/Kconfig:	  This code is experimental and also obsolete. If you want to use it,
./lib/Kconfig.debug:	bool "Enable unused/obsolete exported symbols"
./fs/Kconfig:	bool "Print quota warnings to console (OBSOLETE)"
./fs/Kconfig:	tristate "SMB file system support (OBSOLETE, please use CIFS)"
./arch/powerpc/platforms/iseries/Kconfig:	bool "iSeries Virtual Console Support (Obsolete)"
./arch/arm/Kconfig:	  1995 when it was made obsolete by the PCI bus.
./arch/m68k/Kconfig:	  1995 when it was made obsolete by the PCI bus.
./arch/sh/Kconfig:	  1995 when it was made obsolete by the PCI bus.
./arch/x86/Kconfig:	  1995 when it was made obsolete by the PCI bus.
./arch/mips/Kconfig:	  1995 when it was made obsolete by the PCI bus.
./sound/core/Kconfig:	  Say Y here to support the obsolete ALSA PCM API (ver.0.9.0 rc3

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
