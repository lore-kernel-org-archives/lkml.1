Return-Path: <linux-kernel-owner+w=401wt.eu-S1765627AbXGUNCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765627AbXGUNCG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 09:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbXGUNB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 09:01:56 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:58071 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbXGUNBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 09:01:55 -0400
Date: Sat, 21 Jul 2007 15:02:57 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Message-ID: <20070721130256.GA22671@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: PXA27x UDC driver GIT repository
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

as promised I just published my version of the driver for PXA27x USB
device controller.

You can find all references om my wiki at:

   http://wiki.enneenne.com/index.php/PXA27x_UDC

I reworked the driver according to latest suggestions from you. It's
far from perfection but it's still functional even if I tested it
_only_ with ether gadget. :)

My goal is to have a common code where we all can work together in
order to perfect the code and writing it in order to allow kernel
inclusion.

So every suggestions, modifications and patches all welcomed!

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
