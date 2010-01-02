Return-Path: <linux-kernel-owner+w=401wt.eu-S1751662Ab0ABMSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab0ABMSj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 07:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751112Ab0ABMSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 07:18:38 -0500
Received: from mailout1.go2.pl ([193.17.41.11]:36993 "EHLO mailout1.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab0ABMSi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 07:18:38 -0500
X-Greylist: delayed 945 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Jan 2010 07:18:38 EST
Subject: =?UTF-8?Q?userspace_notification_from_module?=
From: =?UTF-8?Q?Bart=C5=82omiej_Zimo=C5=84?= <uzi18@o2.pl>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Message-ID: <4b387f18.307edfdc.4b3f399c.3bc2e@o2.pl>
Date: Sat, 02 Jan 2010 13:18:36 +0100
X-Originator: 83.12.131.34
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi List!
My name is Bartłomiej Zimoń.

Need some clue to find solution for above topic.
Have written small kernel module to notify userspace about couple events.

The problem is to choose proper way to send data to userspace.

Use inotify from userspace could be interesting for such data,
but looks like sysfs/procfs doesn't send signal about data changed in file or maybe i'm wrong?

If sysfs/procfs is wrong for that so must create device file, but here secound problem 
how to notify that file/buffer has new data?

Please give me some light for such case.
Links to working solutions are also good.

Thanks in advice.

Bartłomiej Zimoń
PLD Linux devel, Kadu Team devel


