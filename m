Return-Path: <linux-kernel-owner+w=401wt.eu-S1765783AbXLMT4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765783AbXLMT4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 14:56:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764913AbXLMT4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 14:56:16 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:52744 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759303AbXLMT4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 14:56:15 -0500
Date: Thu, 13 Dec 2007 20:56:17 +0100
From: Adrian Bunk <bunk@kernel.org>
To: hskinnemoen@atmel.com
Cc: linux-kernel@vger.kernel.org
Subject: Working upstream toolchain for avr32?
Message-ID: <20071213195617.GF21616@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AFAIK the latest available AVR32 toolchains are some patched gcc 4.0 and 
some patched binutils 2.17, and avr32 is currently the only architecture 
in the kernel where upstream of both of them is not capable of building 
a kernel for the architecture.

ALthough not technically a requirement, it would be nice if all Linux 
kernel archs could be compiled with plain upstream toolchains.

Even more since at some point in the future [1] current toolchains might 
no longer be able to compile the then current kernels.

Thanks in advance
Adrian

[1] although it might be a few years from now

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

