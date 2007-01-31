Return-Path: <linux-kernel-owner+w=401wt.eu-S933273AbXAaRp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273AbXAaRp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933250AbXAaRp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:45:28 -0500
Received: from chicken.visionpro.com ([63.91.95.13]:21577 "EHLO
	chicken.machinevisionproducts.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933174AbXAaRp1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:45:27 -0500
X-Ninja-PIM: Scanned by Ninja
X-Ninja-AttachmentFiltering: (no action)
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Section mismatch errors in build
Date: Wed, 31 Jan 2007 09:45:23 -0800
Message-ID: <14CFC56C96D8554AA0B8969DB825FEA001C3A225@chicken.machinevisionproducts.com>
Thread-Topic: Section mismatch errors in build
thread-index: AcdFX5ZQ8iSYmh6JR3iKgTijKcBlUQ==
From: "Brian D. McGrew" <brian@visionpro.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

What do these kind of errors mean???

WARNING: Can't handle masks in drivers/ide/pci/atiixp:FFFF05
WARNING: drivers/mvp/ibb.o - Section mismatch: reference to .exit.data:
from .data between 'ibb_driver' (at offset 0x94) and
'__mod_pci_device_table'
WARNING: drivers/mvp/ibb3d.o - Section mismatch: reference to
.exit.data: from .data between 'ibb3d_driver' (at offset 0x94) and
'__mod_pci_device_table'
WARNING: drivers/mvp/mvp_rtc.o - Section mismatch: reference to
.exit.data: from .data between 'rtc_driver' (at offset 0x94) and
'__mod_pci_device_table'


-brian

Brian D. McGrew        { brian@visionpro.com ||
brian@doubledimension.com }
--
> Do not read this email while waxing that cat! 

