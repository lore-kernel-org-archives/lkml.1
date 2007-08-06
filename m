Return-Path: <linux-kernel-owner+w=401wt.eu-S1763402AbXHFJrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763402AbXHFJrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 05:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761498AbXHFJrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 05:47:09 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:33951 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760599AbXHFJrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 05:47:08 -0400
Date: Mon, 6 Aug 2007 11:48:54 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-kernel@vger.kernel.org
Message-ID: <20070806094854.GC354@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [RFC] Dynamic boot logo
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'd like to have some suggestions from you about how I can implement
the "dynamic boot logo" feature in Linux reading the logo image from
the flash memory.

In my custom board, using u-boot I read a compressed BMP from the
flash memory and then I use it to display the logo, so users just have
to change flash content in order to change their boot logo without
recompiling u-boot.

Could it be possible in Linux also? Which could be, in your opinion,
the best way to solve this problem?

Thanks in advance,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
