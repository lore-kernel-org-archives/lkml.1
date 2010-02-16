Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575Ab0BPJxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 04:53:33 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:39845 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756845Ab0BPJv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 04:51:58 -0500
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Alexander Gordeev <lasaine@lvk.cs.msu.su>
Date: Tue, 16 Feb 2010 10:51:17 +0100
Message-Id: <1266313885-1195-1-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.6.3.3
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: LinuxPPS new functionalities
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds several PPS functionalities.

All patches have a specific comment but I prefer say something more:

* Patches 01-02 are just documentation about PPS support.

* Patch 03 adds PPS client support skeleton.

* Patches 04-06 add generic PPS serial support (with specific
  modifications requested by Alan Cox).

* Patches 07-08 add PPS serial support for specific hardware.

Ciao,

Rodolfo

