Return-Path: <linux-kernel-owner+w=401wt.eu-S1751049AbXCXLfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751049AbXCXLfw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 07:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbXCXLfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 07:35:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:26250 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbXCXLfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 07:35:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=qgRD03tYIOyZxcgUMNQETXXN0PfhK1Zq4okbERJfjP3LDUxBOFZCmiYaB9X087WV3sNpnNUkx6wEFYUFAtV6FtXxAW6trKJwOkjkSOhht12Reup6oGfRsXx+vPjiOoF9cs/S6odGb1vdWjK8a3r0LwMouFA9odPVXyVz85befc0=
Message-ID: <46050D05.1000205@googlemail.com>
Date: Sat, 24 Mar 2007 12:35:33 +0100
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Bryan Wu <bryan.wu@analog.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm snapshot broken-out-2007-03-24-00-14.tar.gz uploaded
References: <200703240816.l2O8GLLS001929@shell0.pdx.osdl.net>
In-Reply-To: <200703240816.l2O8GLLS001929@shell0.pdx.osdl.net>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

akpm@linux-foundation.org napisa³(a):
> The mm snapshot broken-out-2007-03-24-00-14.tar.gz has been uploaded to
> 
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-03-24-00-14.tar.gz
> 
> It contains the following patches against 2.6.21-rc4:

Bryan, your patch (blackfin-arch-2.6.21-rc4-mm1-update.patch) doesn't apply
clean. I've got a lot of "1 out of 1 hunk FAILED -- rejects in file".

Applying patch patches/blackfin-arch-2.6.21-rc4-mm1-update.patch
patching file arch/blackfin/Kconfig
patching file arch/blackfin/Makefile
patching file arch/blackfin/kernel/Makefile
patching file arch/blackfin/kernel/asm-offsets.c
Hunk #1 FAILED at 6.
1 out of 1 hunk FAILED -- rejects in file arch/blackfin/kernel/asm-offsets.c
patching file arch/blackfin/kernel/bfin_dma_5xx.c
Hunk #1 FAILED at 6.
1 out of 17 hunks FAILED -- rejects in file arch/blackfin/kernel/bfin_dma_5xx.c
patching file arch/blackfin/kernel/bfin_gpio.c
Hunk #1 FAILED at 6.
1 out of 12 hunks FAILED -- rejects in file arch/blackfin/kernel/bfin_gpio.c
patching file arch/blackfin/kernel/bfin_ksyms.c
Hunk #1 FAILED at 6.
1 out of 1 hunk FAILED -- rejects in file arch/blackfin/kernel/bfin_ksyms.c
patching file arch/blackfin/kernel/dma-mapping.c
Hunk #1 FAILED at 6.
1 out of 5 hunks FAILED -- rejects in file arch/blackfin/kernel/dma-mapping.c
patching file arch/blackfin/kernel/dualcore_test.c
Hunk #1 FAILED at 6.
1 out of 1 hunk FAILED -- rejects in file arch/blackfin/kernel/dualcore_test.c
patching file arch/blackfin/kernel/entry.S
Hunk #1 FAILED at 6.
1 out of 2 hunks FAILED -- rejects in file arch/blackfin/kernel/entry.S
patching file arch/blackfin/kernel/flat.c
patching file arch/blackfin/kernel/init_task.c
Hunk #1 FAILED at 6.
1 out of 3 hunks FAILED -- rejects in file arch/blackfin/kernel/init_task.c

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
