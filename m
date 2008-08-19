Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbYHSNtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbYHSNtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 09:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756601AbYHSNsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 09:48:53 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:39752 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756597AbYHSNsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 09:48:52 -0400
Date: Tue, 19 Aug 2008 16:48:42 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dhowells@redhat.com, yasutake.koichi@jp.panasonic.com
Cc: linux-kernel@vger.kernel.org
Subject: mn10300: status of ASB2305 support?
Message-ID: <20080819134842.GJ8852@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried to build an ASB2305 kernel [1], and there are many compile 
errors due to references to nonexisting files like asm/cpu/timer-regs.h

What is the status of ASB2305 support?
Is it dead?
Or are there updates somewhere that should get merged into the kernel?

TIA
Adrian

[1] I don't have the hardware

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

