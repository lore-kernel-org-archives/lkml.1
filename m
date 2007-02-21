Return-Path: <linux-kernel-owner+w=401wt.eu-S1161302AbXBUQCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161302AbXBUQCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 11:02:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161299AbXBUQCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 11:02:05 -0500
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:60847 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161302AbXBUQCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 11:02:03 -0500
Date: Wed, 21 Feb 2007 17:02:13 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-kernel@vger.kernel.org
Message-ID: <20070221160213.GK4641@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Advice on backlight support
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'd like to add backlight support for input devices since my custom
board has a backlighted mini keyboard.

It could be acceptable to move the code from drivers/video/backlight/
to drivers/backlight/ renaming the "Backlight & LCD" name into
"Backlight" and adding two new entries "LCD" and, maybe, "Input" (or
something like that?).

Thanks in advance,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
