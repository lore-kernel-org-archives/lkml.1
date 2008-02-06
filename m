Return-Path: <linux-kernel-owner+w=401wt.eu-S1760713AbYBFVBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760713AbYBFVBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 16:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760319AbYBFVA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 16:00:59 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:20322 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757231AbYBFVA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 16:00:58 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ijc@hellion.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Date: Wed,  6 Feb 2008 21:00:37 +0000
Message-Id: <1202331640-15610-1-git-send-email-ijc@hellion.org.uk>
X-Mailer: git-send-email 1.5.4
X-SA-Exim-Connect-IP: 192.168.1.181
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: [PATCHv2 0/3] x86: boot protocol updates.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=RsCASlVCDHsA:10 a=frweXNZgSzYHrrxySyutIQ==:17 a=roIGYi4DrWFZ6JkHVLoA:9 a=m0lixwduQHftDuE2U0D89rP386YA:4 a=jEp0ucaQiEUA:10 a=CY6gl2JlH4YA:10 a=KciULlu47koA:10 a=Je-EC1v4sLEA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updates since last time:
  - Fixed ELF payload patch to work with non-default
    CONFIG_PHYSICAL_START.
  - Grammar fix from Randy Dunlap.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
