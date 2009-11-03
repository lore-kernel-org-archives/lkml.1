Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbZKCSLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbZKCSLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 13:11:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074AbZKCSLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 13:11:22 -0500
Received: from mail.atmel.fr ([81.80.104.162]:41181 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752176AbZKCSLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 13:11:22 -0500
Message-ID: <4AF07242.3070803@atmel.com>
Date: Tue, 03 Nov 2009 19:11:14 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
       kernel <kernel@avr32linux.org>
Subject: [GIT PULL] AT91/AVR32 some common macros
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

If it not bother you too much to pull such a tiny and 
trivial piece of code, can you please pull:

  git://github.com/at91linux/linux-2.6-at91.git for-linus

I directly sent this to you as it require two arch subsystems to 
synchronize. As I have some .32 fixes that are waiting for those 
lines to be merged to go upstream, I thought it was worth a try.

You can receive the following changes:

Nicolas Ferre (2):
      avr32: add two new at91 to cpu.h definition
      at91: at91sam9g45 family: identify several chip versions

 arch/arm/mach-at91/include/mach/cpu.h     |    9 +++++++++
 arch/avr32/mach-at32ap/include/mach/cpu.h |    3 +++
 2 files changed, 12 insertions(+), 0 deletions(-)



-- 
Nicolas Ferre


