Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbZGMLz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbZGMLz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 07:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbZGMLzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 07:55:25 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63518 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497AbZGMLzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 07:55:25 -0400
Message-ID: <4A5B20AF.80205@vlnb.net>
Date: Mon, 13 Jul 2009 15:55:27 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       scst-devel <scst-devel@lists.sourceforge.net>
CC: Stanislaw Gruszka <stf_xl@wp.pl>, Matthew Jacob <lydianconcepts@gmail.com>
Subject: [ANNOUNCE]: SCST target driver for QLocic 24xx adapters qla_isp 1.0.1
 released
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19lAfB0SjN0N+AXSHWumLn1rzjC8ugdmHB7PZO
 tF/9r2GgwP86eRgjI3++W7qsl/BEmtgHSz0xS82o1Wg29HWtHd
 rOj/JertnLREM9jPIUZxQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I'm glad to announce that SCST target driver for QLogic 24xx adapters 
qla_isp version 1.0.1 released and can be downloaded from the SCST 
download page, thanks to Stanislaw Gruszka and Matthew Jacob!

Summary of changes between versions 1.0.0 and 1.0.1
---------------------------------------------------

- Rewritten DMA mappings code.

- Fixed resources leakage when disabling target during pending I/O 
operations.

- Fixed 64 bit Type 3 request breakage.

- Recovery from not being able to push CTIO fix.

- Various task management fixes.

- Fixed OOPS when firmware provide bad VPIDX number.

- Fixed 24xx startup problems.

- In driver firmware images update.

- Various compilation fixes for different gcc and Linux kernel versions.

SCST page of the qla_isp target driver located at 
http://scst.sourceforge.net/target_qla_isp.html.

Vlad
