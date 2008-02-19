Return-Path: <linux-kernel-owner+w=401wt.eu-S1756727AbYBSPjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbYBSPjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 10:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYBSPje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 10:39:34 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:43630 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755275AbYBSPjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 10:39:22 -0500
Date: Tue, 19 Feb 2008 16:39:10 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: ipw3945-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Recent driver in linux kernel 2.6.25-rc2
Message-ID: <20080219153910.GA4303@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 147.251.54.96
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 19 Feb 2008 16:39:11 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

as of pre 2.6.25 kernels, kismet monitoring tool does not work with the message:
# kismet
Launching kismet_server: //usr/bin/kismet_server
Suid priv-dropping disabled.  This may not be secure.
No specific sources given to be enabled, all will be enabled.
Non-RFMon VAPs will be destroyed on multi-vap interfaces (ie, madwifi-ng)
Enabling channel hopping.
Enabling channel splitting.
Source 0 (iwl4965): Enabling monitor mode for iwl4965 source interface wlan0
channel 6...
FATAL: Failed to set channel 6 5:Input/output error
Done.

the same tool works in 2.6.24 kernel.

I have 03:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or
AGN Network Connection (rev 61), 8086:4230 

I have ThinkPad T61 laptop.

Btw, will there be support for LED with iwl4965 driver?

The driver version is 1.2.23ks.

-- 
Luká¹ Hejtmánek
