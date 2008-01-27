Return-Path: <linux-kernel-owner+w=401wt.eu-S1758133AbYA0SOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133AbYA0SOp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 13:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbYA0SOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 13:14:37 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:44705 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbYA0SOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 13:14:36 -0500
X-Greylist: delayed 2277 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Jan 2008 13:14:35 EST
Date: Sun, 27 Jan 2008 18:39:23 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>
Message-ID: <20080127173923.GT11364@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: LinuxPPS patch
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

here my patch for PPS support against kernel 2.6.24:

   http://ftp.enneenne.com/pub/misc/linuxpps/patches/ntp-pps-2.6.24.diff

The code has been tested by some guys intered in PPS stuff and it
seems ok. :)

Please report your suggestions in order to get kernel inclusion.

Thanks in advance,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
