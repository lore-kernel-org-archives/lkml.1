Return-Path: <linux-kernel-owner+w=401wt.eu-S1757968AbZFDMna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbZFDMna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 08:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757722AbZFDMnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 08:43:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:49835 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757796AbZFDMnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 08:43:18 -0400
Subject: [PATCH 0/6] headers_check fix patches 20090604
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Tony Luck <tony.luck@intel.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@snapgear.com>, Ralf Baechle <ralf@linux-mips.org>,
       Michael Abbott <michael@araneidae.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>
Content-Type: text/plain
Date: Thu, 04 Jun 2009 17:53:52 +0530
Message-Id: <1244118232.5172.26.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please Review :

Jaswinder Singh Rajput (6):
      headers_check fix: arm, hwcap.h
      headers_check fix: ia64, fpswa.h
      headers_check fix: m68k, swab.h
      headers_check fix: mips, ioctl.h
      headers_check fix: mn10300, ptrace.h
      headers_check fix: mn10300, setup.h

 arch/arm/include/asm/hwcap.h      |    5 +++--
 arch/ia64/include/asm/fpswa.h     |    3 ++-
 arch/m68k/include/asm/swab.h      |    2 +-
 arch/mips/include/asm/ioctl.h     |    4 ++++
 arch/mn10300/include/asm/ptrace.h |    5 ++---
 arch/mn10300/include/asm/setup.h  |    3 ++-
 6 files changed, 14 insertions(+), 8 deletions(-)

Thanks,
--
JSR

