Return-Path: <linux-kernel-owner+w=401wt.eu-S1759247AbXGKCD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247AbXGKCD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 22:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755865AbXGKCDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 22:03:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:28460 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284AbXGKCDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 22:03:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=jLOMrETgXJqCuNhEVBwFmIIMW8NwUEadRBiznFR4BIq6otTTArDoFFxPllCXjh0k4qjptrhhTpRrXSQngBnP+tiM26M+GIVLEXQsOrsJcRqi6Cn/+0ppA7RYwfrtdzqoH3Gb5uneWVItPgRPtsimlfwInS+DWN1MCpo0xtCep8I=
Date: Wed, 11 Jul 2007 10:04:17 +0000
From: Dave Young <hidave.darkstar@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH][DOC]hpet.txt broken link fix
Message-ID: <20070711100417.GA2013@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The specification link in hpet document is broken.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
Documentation/hpet.txt |    2 +-
1 file changed, 1 insertion(+), 1 deletion(-)

diff -pur linux/Documentation/hpet.txt linux.new/Documentation/hpet.txt
--- linux/Documentation/hpet.txt	2007-07-11 09:37:24.000000000 +0000
+++ linux.new/Documentation/hpet.txt	2007-07-11 09:46:33.000000000 +0000
@@ -5,7 +5,7 @@ for the 8254 and Real Time Clock (RTC) p
 Each HPET can have up to 32 timers.  It is possible to configure the
 first two timers as legacy replacements for 8254 and RTC periodic timers.
 A specification done by Intel and Microsoft can be found at
-<http://www.intel.com/hardwaredesign/hpetspec.htm>.
+<http://www.intel.com/technology/architecture/hpetspec.htm>.
 
 The driver supports detection of HPET driver allocation and initialization
 of the HPET before the driver module_init routine is called.  This enables
