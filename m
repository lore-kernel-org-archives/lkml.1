Return-Path: <linux-kernel-owner+w=401wt.eu-S1756961AbXFPUez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961AbXFPUez (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 16:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbXFPUet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 16:34:49 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:11813 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752750AbXFPUes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 16:34:48 -0400
X-Greylist: delayed 603 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Jun 2007 16:34:48 EDT
X-SBRS: None
X-RemoteIP: 81.1.86.245
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=U_ZtPXakZFMI1wFHrAsA:9 a=IYkuoZEfbASydrU99J1sn4p7fQEA:4
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAPnjc0ZRAVb1/2dsb2JhbAA
X-IronPort-AV: E=Sophos;i="4.16,430,1175468400"; 
   d="scan'208";a="2333368"
Subject: 2.6.22-rc4 not compiling on the SH4/Dreamcast
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: linuxsh-dev@lists.sourceforge.net
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 16 Jun 2007 21:24:11 +0100
Message-Id: <1182025451.6018.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patched 2.6.21.5 - which might be an issue. But this is what I
get:

LD      .tmp_vmlinux1
arch/sh/kernel/built-in.o: In function `restore_all':
arch/sh/kernel/cpu/sh4/../sh3/entry.S:(.text+0x50cc): undefined
reference to `in_nmi'
make: *** [.tmp_vmlinux1] Error 1
