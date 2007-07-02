Return-Path: <linux-kernel-owner+w=401wt.eu-S1755434AbXGBKPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbXGBKPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 06:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbXGBKPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 06:15:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:2120 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbXGBKPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 06:15:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Gahp94b3JvUInDkyEal5j78jlN9qZOw6bPHTfkmBy1vPpBefwTAnhimjCG1B/s4KdMA646w5otBaFkA3nHKkfIMfBicN+8FuAGVZxRt/RBMqu4ZddzzVmYK2gOxIEkDCA5QNsePTBnblocyBJAfFfUnE7g2ndnUtyXKeSZ7IAh0=
Message-ID: <91b13c310707020315v54d19338u817d23d4380bde07@mail.gmail.com>
Date: Mon, 2 Jul 2007 18:15:40 +0800
From: "rae l" <crquan@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Does the kernel HPET support has problems or the hwclock from util-linux?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

from this address, I know util-linux-2.12r is the latest:
http://www.kernel.org/pub/linux/utils/util-linux/util-linux-2.12r.lsm

My Dell OptiPlex 320 has 4 HPET timers and no RTC, so the execution of
hwclock has errors:

gektop@tux ~ $ /sbin/hwclock --show
select() to /dev/rtc to wait for clock tick timed out
gektop@tux ~ $ /sbin/hwclock --version
hwclock from util-linux-2.12r

I wonder is there (kernel.org) a specific description of hwclock and util-linux?

-- 
Denis Cheng
Linux Application Developer
