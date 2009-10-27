Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbZJ0NsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbZJ0NsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 09:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbZJ0NsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 09:48:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59871 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353AbZJ0NsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 09:48:23 -0400
Message-ID: <4AE6FA20.1090609@vlnb.net>
Date: Tue, 27 Oct 2009 16:48:16 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       scst-devel <scst-devel@lists.sourceforge.net>
CC: Stanislaw Gruszka <stf_xl@wp.pl>, Matthew Jacob <lydianconcepts@gmail.com>
Subject: [ANNOUNCE]: SCST target driver for QLogic adapters qla_isp 1.0.2
 released
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+QdAgUA8OtiiIAmJv5EW6fsTWtrqikICYn6ri
 +Y2bHGAR8CeP0WtTmzJpXY0gQFjKjBwgjCR9J0dS9wucW+K1Iz
 CzFiMvsVzVplYn6qWUbKQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I'm glad to announce that SCST target driver for QLogic FC adapters
qla_isp version 1.0.2 released and can be downloaded from the SCST
download page, thanks to Stanislaw Gruszka and Matthew Jacob!

This is, most likely, the final release of this driver. Users of it are 
encouraged to migrate on qla2x00t driver.

Summary of changes between versions 1.0.0 and 1.0.2
---------------------------------------------------

- Support for 2532 chipset (8Gb/s).

- Fixed random firmware crash during startup.

- Fixed problem with N_port login.

- Synchronize with mainline Feral repository (various low level fixes).

- Firmware update, (again) add firmware with multichannel support.

- Fixed oops when stopping kernel thread.

- Fixed residual setting for 21xx/22xx/23xx chipsets.

- Fixed WWN setting for cards with scrambled NVRAM.

- Print information about loop state, link speed and topology in human
   readable form.

- Compilation fixes for kernel up to 2.6.32


SCST page of the qla_isp target driver located at
http://scst.sourceforge.net/target_qla_isp.html.

Vlad

