Return-Path: <linux-kernel-owner+w=401wt.eu-S1756356AbZDOAlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356AbZDOAlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 20:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbZDOAk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 20:40:58 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:57171 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbZDOAk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 20:40:57 -0400
Message-Id: <200904150040.n3F0eDm6039651@www262.sakura.ne.jp>
Subject: patch-2.6.30-rc2.bz2 does not apply cleanly
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 15 Apr 2009 09:40:13 +0900
References: <alpine.LFD.2.00.0904141628570.4132@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904141628570.4132@localhost.localdomain>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 14042009 #1848929, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Did I miss something?

# tar -jxf linux-2.6.29.tar.bz2
# cd linux-2.6.29
# bzcat ../patch-2.6.30-rc2.bz2 | patch -sp1
61 out of 65 hunks FAILED -- saving rejects to file arch/arm/configs/colibri_defconfig.rej
47 out of 59 hunks FAILED -- saving rejects to file arch/arm/configs/xm_x2xx_defconfig.rej
39 out of 50 hunks FAILED -- saving rejects to file arch/arm/configs/xm_x2xx_defconfig.rej
2 out of 2 hunks FAILED -- saving rejects to file drivers/usb/misc/phidget.h.rej
1 out of 1 hunk FAILED -- saving rejects to file include/asm-mn10300/socket.h.rej
33 out of 40 hunks FAILED -- saving rejects to file arch/arm/configs/xm_x2xx_defconfig.rej
33 out of 40 hunks FAILED -- saving rejects to file arch/arm/configs/xm_x2xx_defconfig.rej
42 out of 48 hunks FAILED -- saving rejects to file arch/arm/configs/xm_x2xx_defconfig.rej
45 out of 52 hunks FAILED -- saving rejects to file arch/arm/configs/xm_x2xx_defconfig.rej
2 out of 2 hunks FAILED -- saving rejects to file drivers/usb/storage/sddr55.h.rej
2 out of 2 hunks FAILED -- saving rejects to file drivers/usb/storage/sddr55.h.rej
