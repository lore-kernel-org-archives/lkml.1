Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbYJXJ5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbYJXJ5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 05:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbYJXJ51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 05:57:27 -0400
Received: from mailove.nx.uz ([91.188.134.131]:36279 "EHLO mailove.nx.uz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbYJXJ50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 05:57:26 -0400
Date: Fri, 24 Oct 2008 14:57:22 +0500
From: Terleev Roman <lost@nx.uz>
X-Mailer: SecureBat! Lite (v2.10.02)
Reply-To: Terleev Roman <lost@nx.uz>
Organization: InterNEXT
X-Priority: 3 (Normal)
Message-ID: <116755320.20081024145722@nx.uz>
To: linux-kernel@vger.kernel.org
Subject: Re[2]: PROBLEM: too much RX drop packets on kernel 2.6.26 and 2.6.27.x
In-Reply-To: <200810241110.08643.marc.dietrich@ap.physik.uni-giessen.de>
References: <11610630312.20081024130007@nx.uz>
 <200810241110.08643.marc.dietrich@ap.physik.uni-giessen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=Windows-1251
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello, Marc.
Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>

MD> does the attached patch (from git-net) fix it?
MD> Marc
i try, but nothing change :(

#uname -a
Linux wax.infonet.uz 2.6.27.3 #7 SMP Fri Oct 24 14:00:54 UZT 2008 x86_64 x86_64 x86_64 GNU/Linux

# ifconfig eth0
eth0      Link encap:Ethernet  HWaddr 00:1F:D0:5C:1A:5A  
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:810 errors:0 dropped:176787977669 overruns:0 frame:0
          TX packets:790 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:74274 (72.5 KiB)  TX bytes:164465 (160.6 KiB)
          Interrupt:251 Base address:0x4000

-- 
С уважением,
 Terleev                          mailto:lost@nx.uz

