Return-Path: <linux-kernel-owner+w=401wt.eu-S1756420AbXIXJyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbXIXJyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 05:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbXIXJx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 05:53:57 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:52121 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbXIXJx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 05:53:56 -0400
X-Greylist: delayed 3041 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Sep 2007 05:53:56 EDT
Message-ID: <41784.213.84.50.107.1190624288.squirrel@webmail.enneenne.com>
Date: Mon, 24 Sep 2007 10:58:08 +0200 (CEST)
From: "Rodolfo Giometti" <giometti@enneenne.com>
To: Linux-fbdev-devel@lists.sourceforge.net, i2c@lm-sensors.org
Cc: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.4
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [RFC] driving a LCD panel via I2C
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have an LCD panel on a custom PXA27x based board and it must be turned
on/off by some special commands via a GPIO throught a I2C chip.

I'd like some suggestion about I can easily manage this situation.

Maybe can I add a special I2C function to get i2c_client pointer and then
using it to send on/off commands to the LCD?

Thanks in advance,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127


