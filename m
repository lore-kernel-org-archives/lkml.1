Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbXE3Q4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbXE3Q4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 12:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbXE3Q4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 12:56:08 -0400
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:40536 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbXE3Q4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 12:56:07 -0400
Date: Wed, 30 May 2007 18:57:05 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-kernel@vger.kernel.org
Message-ID: <20070530165705.GD29337@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: mmc0: unrecognised SCR structure version 1
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

using MMC/SD support on my PXA270 based board I get this error:

   mmc0: unrecognised SCR structure version 1

when I insert a MINISD card.

I tried to find on the net some specifications for the SCR structure
version 1 but I found nothing useful... someone has a similar problem
or can suggest to me where I can find such specifications?

Thanks,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
