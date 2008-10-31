Return-Path: <linux-kernel-owner+w=401wt.eu-S1751871AbYJaLpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871AbYJaLpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 07:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbYJaLpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 07:45:04 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:28468 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbYJaLpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 07:45:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=uEDMFXk6Zgs98W9l1qhsQUsYta8DHgQcyYGSGkRmqRRCF0SP4wjpkxXKX805FLiN4O
         M/+lP1nPJvycMD5NNsc1xNQ6U4GeFj3nrO43vjDpz0FXsGruc6w5pVB5Q18gaDd+Cx8G
         RDTOVj3DRFDp+VLSEI23t6tdDnT5bAGzJOEXQ=
Message-ID: <4104961b0810310445v49e13b85xe85d417bfe9ad979@mail.gmail.com>
Date: Fri, 31 Oct 2008 19:45:02 +0800
From: "jidong xiao" <jidong.xiao@gmail.com>
To: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Where is asm-ia64 directory in 2.6.27 kernel?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just noticed there is no such a directory now, where are the
including files re-located?Is it also merged into asm-x86??

lfs:/usr/src/linux-2.6.27-rc2/include # ls
acpi       asm-blackfin  asm-h8300      asm-mips     asm-x86
Kbuild    media   rdma   video
asm-alpha  asm-cris      asm-m32r       asm-mn10300  asm-xtensa  keys
    mtd     rxrpc  xen
asm-arm    asm-frv       asm-m68k       asm-parisc   crypto      linux
    net     scsi
asm-avr32  asm-generic   asm-m68knommu  asm-um       drm
math-emu  pcmcia  sound

Regards
Jason
