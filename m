Return-Path: <linux-kernel-owner+w=401wt.eu-S1757418AbXJ2K0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbXJ2K0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 06:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbXJ2K0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 06:26:39 -0400
Received: from rzcomm22.rz.tu-bs.de ([134.169.9.68]:53235 "EHLO
	rzcomm22.rz.tu-bs.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbXJ2K0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 06:26:38 -0400
Message-ID: <4725B553.4060502@l4x.org>
Date: Mon, 29 Oct 2007 11:26:27 +0100
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: dhowells@redhat.com
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Working frv toolchain?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With gcc 4.0.0 and binutils 2.15.94 I get:

   CC      arch/frv/mm/dma-alloc.o
arch/frv/mm/dma-alloc.c: In function 'consistent_alloc':
arch/frv/mm/dma-alloc.c:66: error: impossible constraint in 'asm'
make[2]: *** [arch/frv/mm/dma-alloc.o] Error 1
make[1]: *** [arch/frv/mm] Error 2
make: *** [sub-make] Error 2

http://l4x.org/k/?d=35919 for details

What is a known working toolchain for fr-v? Is there a
mailing list for frv related problems?

Thanks,

Jan
