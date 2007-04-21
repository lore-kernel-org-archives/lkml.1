Return-Path: <linux-kernel-owner+w=401wt.eu-S1030628AbXDUOSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030628AbXDUOSZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 10:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030866AbXDUOSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 10:18:25 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:36036 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030628AbXDUOSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 10:18:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=YK7zMVvZLjiCiDf1i/Q2YPYfrgl0FooY8xBAdnKB7r5FadzzwM5GVidoxh2IsCmVtvxyQrKdBxJDFEseBUjG/9R1kTRg/zP4wFuUvbNJDkvbFeBb/AZEXg0Eadzldl2j+TjVWrBRs+bRQehtoTgFFxGFFYPN66I5ouzecjgJbck=
Message-ID: <254054bc0704210718t20ec96et3b7ab82ef783684f@mail.gmail.com>
Date: Sat, 21 Apr 2007 16:18:01 +0200
From: "Wiktor Wandachowicz" <siryes@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Kernel 2.6.20+ and rt2500/rt2570 problem
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Recently I tried newer releases of Linux distributions, specifically
Sabayon Linux 3.3 and Ubuntu 7.04. Both suffer from problems with
rt2500/rt2570 modules not being able to associate with access points.
There are numerous problems reported Ubuntu Launchpad, Gentoo Forums
and Sabayon Forums.

Please, Linux kernel developers, try to help out the guys at:
http://rt2x00.serialmonkey.com/

They look pretty clueless and don't know exactly what to do.
It seems that advances in kernel to Wireless Extensions 19 broke
their efforts somewhat.

If possible, speed up the inclusion process of the driver into mainline
kernel, so users won't have to be forced to do a hardware upgrade.
Additionally, this problem prevents my machines from being upgraded from
Ubuntu 6.10 (kernel 2.6.17) to Ubuntu 7.04 (kernel 2.6.20 I believe).

With kind regards,
Wiktor Wandachowicz


[1] http://rt2x00.serialmonkey.com/phpBB2/viewtopic.php?t=3477
[2] http://rt2x00.serialmonkey.com/phpBB2/viewtopic.php?t=3543
[3] http://rt2x00.serialmonkey.com/phpBB2/viewtopic.php?t=3552
[4] http://rt2x00.serialmonkey.com/phpBB2/viewtopic.php?t=3571
[5] http://www.sabayonlinux.org/forum/viewtopic.php?t=5013
[6] http://www.sabayonlinux.org/forum/viewtopic.php?t=5239
[7] http://www.sabayonlinux.org/forum/viewtopic.php?t=5305

-- 
Registered Linux user #390131 (http://counter.li.org)
