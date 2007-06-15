Return-Path: <linux-kernel-owner+w=401wt.eu-S1755831AbXFOQKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbXFOQKS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 12:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbXFOQKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 12:10:06 -0400
Received: from mba.ocn.ne.jp ([122.1.175.29]:56393 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbXFOQKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 12:10:05 -0400
Date: Sat, 16 Jun 2007 01:10:37 +0900 (JST)
Message-Id: <20070616.011037.59464869.anemo@mba.ocn.ne.jp>
To: linux-kernel@vger.kernel.org
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com
Subject: RTC_CLASS is still considered as EXPERIMENTAL?
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The generic RTC subsystem was added to kernel 2.6.17 which was
released a years ago.  Since then, many drivers were added to the
subsystem without major API changes, I think.

It is mature enough to remove EXPERIMENTAL label from RTC_CLASS, isn't
it?

---
Atsushi Nemoto
