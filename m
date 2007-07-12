Return-Path: <linux-kernel-owner+w=401wt.eu-S1765540AbXGLQYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765540AbXGLQYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 12:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757359AbXGLQYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 12:24:43 -0400
Received: from relay2.ptmail.sapo.pt ([212.55.154.22]:44737 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1757343AbXGLQYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 12:24:42 -0400
X-AntiVirus: PTMail-AV 0.3-0.90.3
Date: Thu, 12 Jul 2007 17:24:50 +0100
From: =?iso-8859-1?Q?R=FAben?= Fonseca <krani1@0x82.com>
To: Linux Kernel Mailling List <linux-kernel@vger.kernel.org>
Subject: libata [ata_piix] still no resume from S3 ?
Message-ID: <20070712162450.GA7132@0x82.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi to all!

I'm on Debian Sid with kernel 2.6.21 and I still can't resume my laptop
(Sony Vaio SZ2) from S3. Searched on the archive and it seems that SATA 
drives are getting problems when used via the "new" libata. When the
laptop tries to resume, it can't access the hard drive anymore (the LED
never blinks), the filesystem is mounted read-only and of course, the
system hangs. I still can see a "Lost interrupt" apearing on my LCD when
it is resuming. Sometimes it is IRQ 22, other times it is IRQ 23.

Is this still a know problem? Does 2.6.22 solve this already? If you
need more information about my environment, please ask :)

Ruben

-- 
Will work for bandwidth
