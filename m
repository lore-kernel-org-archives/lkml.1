Return-Path: <linux-kernel-owner+w=401wt.eu-S1753270AbYLFSwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbYLFSwv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 13:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbYLFSwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 13:52:44 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:59760 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbYLFSwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 13:52:43 -0500
Date: Sat, 6 Dec 2008 19:52:52 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: linux-kernel@vger.kernel.org
Subject: LibATA error
Message-ID: <20081206185252.GA4323@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 85.132.163.129
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Sat, 06 Dec 2008 19:52:40 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

what does the following error mean? Does it mean that my shiny new SSD is
buggy?

[  461.382432] ata1.00: exception Emask 0x2 SAct 0x1 SErr 0x2000000 action 0x6
frozen
[  461.382484] ata1.00: irq_stat 0x00000010, unknown FIS 00000000 00000000
00000000 00000000
[  461.382534] ata1: SError: { UnrecFIS }
[  461.382572] ata1.00: cmd 61/08:00:0f:82:de/00:00:00:00:00/40 tag 0 ncq 4096
out
[  461.382574]          res 40/00:00:0f:82:de/00:00:00:00:00/40 Emask 0x2 (HSM
violation)
[  461.382666] ata1.00: status: { DRDY }
[  461.382702] ata1: hard resetting link
[  461.700087] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)

-- 
Luká¹ Hejtmánek
