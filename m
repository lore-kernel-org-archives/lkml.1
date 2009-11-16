Return-Path: <linux-kernel-owner+w=401wt.eu-S1752683AbZKPLXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbZKPLXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 06:23:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbZKPLXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 06:23:04 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52464 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbZKPLXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 06:23:01 -0500
Date: Mon, 16 Nov 2009 12:23:05 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: ibm-acpi@hmh.eng.br, ibm-acpi-devel@lists.sourceforge.net
Subject: -rc6: annoying thermal messages
Message-ID: <20091116112304.GC12315@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


My dmesg log is rather full of. Thinkpad x60.
							Pavel

	

wlan0: RX AssocResp from 00:11:95:05:30:d7 (capab=0x421 status=0
aid=2)
wlan0: associated
wlan0: deauthenticated from 00:11:95:05:30:d7 (Reason: 3)
thinkpad_acpi: THERMAL EMERGENCY: a sensor reports something is
extremely hot!
thinkpad_acpi: THERMAL EMERGENCY: a sensor reports something is
extremely hot!
thinkpad_acpi: THERMAL EMERGENCY: a sensor reports something is
extremely hot!
thinkpad_acpi: THERMAL EMERGENCY: a sensor reports something is
extremely hot!
thinkpad_acpi: THERMAL EMERGENCY: a sensor reports something is
extremely hot!
thinkpad_acpi: THERMAL EMERGENCY: a sensor reports something is
extremely hot!
thinkpad_acpi: THERMAL EMERGENCY: a sensor reports something is
extremely hot!
thinkpad_acpi: THERMAL EMERGENCY: a sensor reports something is
extremely hot!
thinkpad_acpi: THERMAL EMERGENCY: a sensor reports something is
extremely hot!
thinkpad_acpi: THERMAL EMERGENCY: a sensor reports something is
extremely hot!
thinkpad_acpi: THERMAL EMERGENCY: a sensor reports something is
extremely hot!
thinkpad_acpi: THERMAL EMERGENCY: a sensor reports something is
extremely hot!
thinkpad_acpi: THERMAL EMERGENCY: a sensor reports something is
extremely hot!
hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0004
ehci_hcd 0000:00:1d.7: GetStatus port 2 status 001002 POWER sig=se0
CSC
hub 1-0:1.0: port 2, status 0100, change 0001, 12 Mb/s
usb 1-2: USB disconnect, address 6

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
