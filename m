Return-Path: <linux-kernel-owner+w=401wt.eu-S1761371AbXH3Uwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761371AbXH3Uwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 16:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757033AbXH3Uwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 16:52:43 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:37178 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbXH3Uwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 16:52:43 -0400
X-Auth-Info: hGcqQH5u8ozVszcHJQeaCUHAlAy5MxAKo3OgJrbatj0=
Subject: IBM ThinkPad T23: Uhhuh. NMI received for unknown reason 30 on CPU
	0.
From: Stefan Foerster <stefan.foerster@mnet-online.de>
Reply-To: stefan.foerster@mnet-online.de
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: United Federation of Planets
Date: Thu, 30 Aug 2007 22:52:40 +0200
Message-Id: <1188507160.4640.18.camel@stefan2>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

on my IBM ThinkPad T23 I often get the following messages (together with
a beep from the speaker):

-------------------
Message from syslogd@stefan2 at Thu Aug 30 22:02:17 2007 ...
stefan2 kernel: Uhhuh. NMI received for unknown reason 30 on CPU 0.

Message from syslogd@stefan2 at Thu Aug 30 22:02:17 2007 ...
stefan2 kernel: Do you have a strange power saving mode enabled?

Message from syslogd@stefan2 at Thu Aug 30 22:02:17 2007 ...
stefan2 kernel: Dazed and confused, but trying to continue

stefan@stefan2:~$ 
Message from syslogd@stefan2 at Thu Aug 30 22:32:08 2007 ...
stefan2 kernel: Do you have a strange power saving mode enabled?

Message from syslogd@stefan2 at Thu Aug 30 22:32:08 2007 ...
stefan2 kernel: Dazed and confused, but trying to continue

Message from syslogd@stefan2 at Thu Aug 30 22:32:08 2007 ...
stefan2 kernel: Uhhuh. NMI received for unknown reason 30 on CPU 0.
------------------

There seems to be no pattern in the "interarrival times" of this signal.
Sometimes I get it about every 30 minutes, sometimes only once a day.

It also doesn't depend on the kernel version. I now see this behaviour
on this notebook for 3 years now.

My current kernel version is 2.6.23-rc3 (plain vanilla kernel), Ubuntu
Gutsy Gibbon.

I have googled "Uhhuh. ..." and got exactly 3 (!) entries, but no
solution. But it seems that this is somehow typical for some notebooks,
especially ThinkPads.

Any ideas ?


Stefan

