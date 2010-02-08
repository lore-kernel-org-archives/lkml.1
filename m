Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab0BHKxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 05:53:17 -0500
Received: from mail-fx0-f211.google.com ([209.85.220.211]:63406 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab0BHKxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 05:53:13 -0500
Message-ID: <4B6FEC8A.5000606@monstr.eu>
Date: Mon, 08 Feb 2010 11:50:50 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze fixes for 2.6.33-rc8
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

we found BUG around caches that's why please pull the following
one patch.

Thanks,
Michal


The following changes since commit 6339204ecc2aa2067a99595522de0403f0854bb8:
   Linus Torvalds (1):
         Merge branch 'for-linus' of git://git.kernel.org/.../viro/vfs-2.6

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git for-linus

Michal Simek (1):
       microblaze: Invalidate dcache before enabling it

  arch/microblaze/kernel/setup.c |    1 +
  1 files changed, 1 insertions(+), 0 deletions(-)


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
