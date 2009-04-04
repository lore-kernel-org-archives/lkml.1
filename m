Return-Path: <linux-kernel-owner+w=401wt.eu-S1756405AbZDDSGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbZDDSGR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 14:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754552AbZDDSGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 14:06:01 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:53946 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753952AbZDDSGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 14:06:00 -0400
X-Trace: 176879433/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.47.161/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.41.47.161
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-MUA: Evolution 2.24.3 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAPI910lQKS+h/2dsb2JhbACBUspAhA8G
X-IronPort-AV: E=Sophos;i="4.39,324,1235952000"; 
   d="scan'208";a="176879433"
Subject: CONFIG_FW_LOADER
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 04 Apr 2009 19:05:48 +0100
Message-Id: <1238868348.6489.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the help for this states: 


CONFIG_FW_LOADER:
This option is provided for the case where no in-kernel-tree modules
require userspace firmware loading support, but a module built outside
the kernel tree does.


Is it just me or is this somewhat misleading? Don't all modules that
load firmware from userspace require this?

