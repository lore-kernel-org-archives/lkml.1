Return-Path: <linux-kernel-owner+w=401wt.eu-S1759236AbYGPPSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236AbYGPPSD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 11:18:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756201AbYGPPRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 11:17:51 -0400
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:59662 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756045AbYGPPRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 11:17:50 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19Sf9rPL/AeNku59mu1k70T
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@lists.linux-foundation.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-omap@vger.kernel.org,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 0/0] Power domain and clock domain patches for omap
Date: Wed, 16 Jul 2008 18:19:05 +0300
Message-Id: <1216221555-18958-1-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.5.6.rc3.21.g8c6b5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This patch series contains power domain and clock domain specific patches
for omap posted to linux-arm-kernel list during 2.6.25-rc5.

I'm reposting the series to a wider audience as Russell King suspected that
other archs may be interested in reviewing these too, or at least some
parts of the code.

Please take a look and comment the code. Also please point out the pieces of
code that may be suitable for your arch too!

This patch series also available via git at:

git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap2-clock

Regards,

Tony
