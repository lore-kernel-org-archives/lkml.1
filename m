Return-Path: <linux-kernel-owner+w=401wt.eu-S1759604AbXJLGlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759604AbXJLGlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 02:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbXJLGlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 02:41:16 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:43675 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbXJLGlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 02:41:15 -0400
Subject: CPU speed after hibernation
From: Bhasker C V <bcv@unixindia.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Fri, 12 Oct 2007 12:11:07 +0530
Message-Id: <1192171267.6631.8.camel@h1.unixindia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

 I have enable suspend-to-disk on myetch system K 2.6.21.1
 I have enabled acpi cpu frequency scaling and using "convservative"
governer.

 When I boot the system, the cpu frequency works switches fine based on
the requirement. But when i go to hibernation and come back from
hibernation, the cpu frequency gets stuck at the maximum. 

 I have already written to debian-users list but did not get any reply
(with the same subject line). 
 Is this a known issue ?
 If i try to remove and re-insert the cpufreq_conservative module, the
whole system hangs.

thanks
-- 
Bhasker C V
To feel rich count all things you have in life that money can't buy.

