Return-Path: <linux-kernel-owner+w=401wt.eu-S1754463AbXI1Khj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbXI1Khj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 06:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbXI1Khb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 06:37:31 -0400
Received: from mta3.th.hotchilli.net ([62.89.140.53]:41022 "EHLO
	smtp.hotchilli.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbXI1Kha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 06:37:30 -0400
X-Greylist: delayed 1721 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Sep 2007 06:37:30 EDT
From: bill purvis <bil@beeb.net>
Reply-To: bil@beeb.net
To: linux-kernel@vger.kernel.org
Subject: Problem with booting new kernel on Toshiba Equium Laptop
Date: Fri, 28 Sep 2007 11:08:46 +0100
User-Agent: KMail/1.7.1
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709281108.46947.bil@beeb.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have been putting off updating my kernel for far too long.
I am currently running 2.6.8.1 (Mandrake distribution) which ran
fine straight off the distribution CDROM. I did try downloading the
then current kernel (2.11.??) from kernel.org and rebuilding it
to match my system but when I tried to boot it just hung up
immediately after loading. I couldn't see any reason why, but as
it wasn't a desperate need to update I abandoned this.
More recently I need to update so I downloaded the latest stable
version (2.6.22.8), configured it and installed it as a test
kernel. This behaved in much the same way as the earlier attempt -
the Lilo prompt came up, I selected the test kernel, the progress
bar indicated kernel loading, then the screen goes blank and
no further action. Power off and reboot and try again, same.
Power off and reboot old kernel, fine. Nothing in /var/log/messages.
Nothing in /var/log/kernel/errors.

I'm not a kernel guru at all, and I'd really appreciate anyone
who can offer me advice on how to figure out what's going on.

Please respond directly as I'm not subscribed to the list
and I'd prefer not to bother other people more than neccesary.

Bill
-- 
+---------------------------------------+
| Bill Purvis, Amateur Mathematician    |
|  email: bil@beeb.net                  |
|  http://bil.members.beeb.net          |
+---------------------------------------+
