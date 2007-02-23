Return-Path: <linux-kernel-owner+w=401wt.eu-S1750924AbXBWFvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750924AbXBWFvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 00:51:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbXBWFvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 00:51:12 -0500
Received: from gherkin.frus.com ([192.158.254.49]:1106 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbXBWFvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 00:51:12 -0500
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Feb 2007 00:51:11 EST
Subject: 2.6.21-rc1: Ethernet card not detected correctly (followup)
To: linux-kernel@vger.kernel.org
Date: Thu, 22 Feb 2007 23:51:07 -0600 (CST)
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070223055107.C429BDBA2@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I forgot to include some possibly useful "lspci -v" output.  This
is while running 2.6.20:

00:0a.0 Ethernet controller: National Semiconductor Corporation DP83815 (MacPhyter) Ethernet Controller
        Subsystem: Netgear FA311 / FA312 (FA311 with WoL HW)
	Flags: bus master, medium devsel, latency 32, IRQ 12
	I/O ports at dc00 [size=256]
	Memory at df005000 (32-bit, non-prefetchable) [size=4K]
	Expansion ROM at 20020000 [disabled] [size=64K]
	Capabilities: [40] Power Management version 2

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
