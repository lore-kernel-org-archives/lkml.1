Return-Path: <linux-kernel-owner+w=401wt.eu-S1759891AbXIYQ3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759891AbXIYQ3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 12:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbXIYQ3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 12:29:46 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:57318
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752847AbXIYQ3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 12:29:46 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Sep 2007 12:29:45 EDT
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Transfer-Encoding: 7bit
Message-Id: <6D36DFB9-B26D-4CEA-B7AD-0216F7124FC5@it-loops.com>
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
To: linux-kernel@vger.kernel.org
From: Michael Guntsche <mike@it-loops.com>
Subject: 2.6.23 /proc/bus/input/devices content question
Date: Tue, 25 Sep 2007 18:23:01 +0200
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After upgrading to 2.6.23-rc7 for testing purposes I noticed that the  
contents of /proc/bus/input/devices changed a little bit.

I now have the following entries for my USB-keyboard

....
P: Phys=usb-0000:00:1d.0-2/input0
S: Sysfs=/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/input/input2
....

with kernel < 2.6.23 I saw

....
P: Phys=/input0
S: Sysfs=/class/input/input0
....

I this a "wanted" change or should I still see the same with 2.6.23?

Kind regards,
Michael
