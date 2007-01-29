Return-Path: <linux-kernel-owner+w=401wt.eu-S1752522AbXA2RtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbXA2RtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 12:49:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbXA2RtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 12:49:25 -0500
Received: from hanoi.cronyx.ru ([144.206.181.53]:64250 "EHLO hanoi.cronyx.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbXA2RtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 12:49:25 -0500
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jan 2007 12:49:24 EST
Date: Mon, 29 Jan 2007 20:38:18 +0300
From: Leo Yuriev <ly@hanoi.cronyx.ru>
X-Mailer: The Bat! (v3.95.6) Professional
Reply-To: Leo Yuriev <ly@hanoi.cronyx.ru>
Organization: Cronyx Engineering
X-Priority: 3 (Normal)
Message-ID: <1833199799.20070129203818@hanoi.cronyx.ru>
To: linux-kernel@vger.kernel.org
Subject: 2.6.19 + VIA EPIA = very mysterious RESET-problem :(
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by hanoi.cronyx.ru id l0THcNti000687
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Good day.

I have a really big trouble with VIA-EPIA mainboards under Linux
2.6.19. After loading kernel Linux the RESET-circuit ceases to work
correctly.

At reset (by RESET-button or by Watchdog) the system begins to be
restarted, but hangs before occurrence of any BIOS-messages. Only a
power-off and then power-up can help. The problem has been reproduced
confidently and constantly, I has checked up about 20 mainboards (EPIA-
EN/C7 and EPIA-PD/C3).

I am sure, this is not a Linux-related problem, but error in hardware
design or BIOS-code. Because RESET-circuit must work always and be
independent from a running software.

VIA's support doesn't give any usable response. But now I just need
some workaround...

Does somebody has ideas?
I can make some tests or perform deep-debugging, but currently I don't
know where I could start from.

Thank in advance.

--
 С уважением, / Best regards,
 Леонид Юрьев / Leo Yuriev
   КБ Кроникс / Cronyx Engineering

 mailto:ly@hanoi.cronyx.ru


