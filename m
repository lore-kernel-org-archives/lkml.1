Return-Path: <linux-kernel-owner+w=401wt.eu-S1755768AbXIOTM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbXIOTM3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 15:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbXIOTMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 15:12:23 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:34857 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbXIOTMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 15:12:22 -0400
X-Greylist: delayed 696 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Sep 2007 15:12:22 EDT
Date: Sat, 15 Sep 2007 21:00:16 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: linux-kernel@vger.kernel.org
Subject: CPU usage for 10Gbps UDP transfers
Message-ID: <20070915190016.GA3868@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Envelope-To: linux-kernel@vger.kernel.org
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sat, 15 Sep 2007 21:00:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

is it expected that application sending 8900bytes datagram through 10Gbps NIC
utilizes CPU to 100% and similarly the receiver also utilizes CPU to 100%.
Is it something wrong or this is quite OK?

(The box is dual single core Opteron 2.4GHz with Myricom 10GE NIC.)

-- 
Luká¹ Hejtmánek
