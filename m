Return-Path: <linux-kernel-owner+w=401wt.eu-S1756616AbXKBAas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbXKBAas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 20:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbXKBAak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 20:30:40 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:57343 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbXKBAaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 20:30:39 -0400
Date: Fri, 2 Nov 2007 01:30:38 +0100
To: linux-kernel@vger.kernel.org
Subject: Re: Major SATA / EXT3 Issue?
Message-ID: <20071102003038.GB25692@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

(Please Cc)

I alsohave to report a very similar incident. Debian/sid, kernel 2.6.22.
Doing some hard work for the disk (svn up of two big repositories, some
copying of files, etc etc).

Suddently the PC froze. Nothing, I had to reboot. But then:
- BIOS didn't detect the disks, or better, it took extremely long
- booting into linux gave those time out messages already mentioned (I
  am away, cannot give you details for now till sunday)
- booting into windows frooze windows when accessing the second harddisk
  (from which stuff was copied).
- reseting the computer didn't help., but turning physically off, and
  turning on again did the trick, some fsck-ing.
- booting into windows needed chkdsk from ewindows, and severalk files
  destroyed.

Both the disks and the computer are quite new, and are NOT heavily used,
only now and then.

AFAIR nv SATA driver.

Ic ould repeat these problems with big copying actions.

The problem with logging is that the computer freezes hard and nothing
remains in the log files.

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
JARROW (adj.)
An agricultural device which, when towed behind a tractor, enables the
farmer to spread his dung evenly across the width of the road.
			--- Douglas Adams, The Meaning of Liff
