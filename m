Return-Path: <linux-kernel-owner+w=401wt.eu-S1756975AbYBMUzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975AbYBMUzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 15:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbYBMUzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 15:55:23 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:27386 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751259AbYBMUzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 15:55:22 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ijc@hellion.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Date: Wed, 13 Feb 2008 20:54:57 +0000
Message-Id: <1202936100-30859-1-git-send-email-ijc@hellion.org.uk>
X-Mailer: git-send-email 1.5.4
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: [PATCHv3 0/3] x86: boot protocol updates.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=Oo48PZ5V5CUA:10 a=qcrRp5rlbqkS0d6TfuPTVw==:17 a=roIGYi4DrWFZ6JkHVLoA:9 a=9zPgKlNcm4V2c51gUyo91ZgWIuIA:4 a=jEp0ucaQiEUA:10 a=CY6gl2JlH4YA:10 a=KciULlu47koA:10 a=Je-EC1v4sLEA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updates since last time:
  - Rebased to latest x86.git#mm (no changes required).

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
