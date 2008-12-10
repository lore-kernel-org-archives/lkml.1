Return-Path: <linux-kernel-owner+w=401wt.eu-S1757855AbYLJSeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855AbYLJSeB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 13:34:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757063AbYLJSav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 13:30:51 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:56088 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756929AbYLJSau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 13:30:50 -0500
Message-ID: <49400ACD.3070502@vlnb.net>
Date: Wed, 10 Dec 2008 21:30:37 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net,
       Bart Van Assche <bart.vanassche@gmail.com>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH][RFC 2/23]: SCST core
References: <494009D7.4020602@vlnb.net>
In-Reply-To: <494009D7.4020602@vlnb.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/Gkhk0q3wX8t65G13aP0e51jDPEHWK5ryIjLV
 sBXgvyMWH98y4T+xTHHwrQBgyE2TuT4FkLk3DLr9AI/aRoLpc0
 8SKrf22JdCg/AVrN3xobQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains SCST core code.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
  drivers/scst/Kconfig         |  256 ++
  drivers/scst/Makefile        |   12
  drivers/scst/scst_cdbprobe.h |  519 +++++
  drivers/scst/scst_lib.c      | 3689 +++++++++++++++++++++++++++++++++++++
  drivers/scst/scst_main.c     | 1919 +++++++++++++++++++
  drivers/scst/scst_module.c   |   69
  drivers/scst/scst_priv.h     |  513 +++++
  drivers/scst/scst_targ.c     | 5458 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  8 files changed, 12435 insertions(+)

The patch is too big to be submitted inline. You can find it in 
http://scst.sourceforge.net/patches/scst_core.diff


