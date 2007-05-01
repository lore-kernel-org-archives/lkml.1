Return-Path: <linux-kernel-owner+w=401wt.eu-S1423467AbXEAA5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423467AbXEAA5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 20:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423468AbXEAA5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 20:57:10 -0400
Received: from clem.clem-digital.net ([68.16.168.10]:54222 "EHLO
	clem.clem-digital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423467AbXEAA5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 20:57:09 -0400
X-Greylist: delayed 746 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Apr 2007 20:57:08 EDT
From: Pete Clements <clem@clem.clem-digital.net>
Message-Id: <200705010044.l410ifIv003245@clem.clem-digital.net>
Subject: 2.6.21-git3 Broke UDP Reception
To: linux-kernel@vger.kernel.org (linux-kernel)
Date: Mon, 30 Apr 2007 20:44:41 -0400 (EDT)
X-Mailer: ELM [version 2.5 PL7]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

fyi:
Looks like 2.6.21-git3 broke UDP inbound. Inbound UDP traffic
generates an ICMP port unreachable, dns/ntp. Git2 works fine.
-- 
Pete Clements 
