Return-Path: <linux-kernel-owner+w=401wt.eu-S1760790AbXESHAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760790AbXESHAf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 03:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbXESHA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 03:00:29 -0400
Received: from muan.mtu.ru ([195.34.34.229]:2354 "EHLO muan.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbXESHA2 (ORCPT <rfc822; linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 03:00:28 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 May 2007 03:00:28 EDT
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: Linux 2.6.22-rc2
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Date: Sat, 19 May 2007 10:54:50 +0400
References: <alpine.LFD.0.98.0705182209030.3890@woody.linux-foundation.org>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <20070519065452.8ED693A1B93@muan.mtu.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:

> 
> It's out there, both patches/tarballs and git trees are updated (although
> mirroring might still be ongoing)
> 

trivia

make: Entering directory `/home/bor/src/linux-git'
  GEN     /home/bor/build/linux-2.6.22/Makefile
scripts/kconfig/conf -s arch/i386/Kconfig
drivers/macintosh/Kconfig:116:warning: 'select' used by config
symbol 'PMAC_APM_EMU' refers to undefined
symbol 'SYS_SUPPORTS_APM_EMULATION'
drivers/net/Kconfig:2283:warning: 'select' used by config symbol 'UCC_GETH'
refers to undefined symbol 'UCC_FAST'
drivers/input/keyboard/Kconfig:170:warning: 'select' used by config
symbol 'KEYBOARD_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
drivers/input/mouse/Kconfig:182:warning: 'select' used by config
symbol 'MOUSE_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'



