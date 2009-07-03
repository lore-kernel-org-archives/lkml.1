Return-Path: <linux-kernel-owner+w=401wt.eu-S1757987AbZGCCTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbZGCCTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 22:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757527AbZGCCTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 22:19:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:41815 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757950AbZGCCTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 22:19:03 -0400
Subject: Reminder for feature usedac i386 kernel parameter removal date
 2.6.29 March 2009
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Krzysztof Piotr Oledzki <ole@ans.pl>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 03 Jul 2009 07:46:50 +0530
Message-Id: <1246587410.2530.19.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

What: CONFIG_NF_CT_ACCT
When: 2.6.29
Why:  Accounting can now be enabled/disabled without kernel recompilation.
      Currently used only to set a default value for a feature that is also
      controlled by a kernel/module/sysfs/sysctl parameter.
Who:  Krzysztof Piotr Oledzki <ole@ans.pl>

If you are facing any issue regarding feature removal kindly update the
"Documentation/feature-removal-schedule.txt" like what you are waiting
for.

Thanks,
--
JSR

http://userweb.kernel.org/~jaswinder/

