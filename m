Return-Path: <linux-kernel-owner+w=401wt.eu-S1752602AbZIGJtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbZIGJtD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 05:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbZIGJtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 05:49:03 -0400
Received: from mail-pz0-f192.google.com ([209.85.222.192]:56539 "EHLO
	mail-pz0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbZIGJtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 05:49:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc
         :subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=Uhh63+q0rCK6aoJp2zJ4K+DTkUGaLtl5ssmEPNu6ker5//pSrcch8xSuOO3vmJzGJ1
         oWHmXgYIJWhj1p76w+2K+2TNy1qvD/MU1lriupfKIX2FiioiY+XJyBAgLypiHJE0mI/q
         rhntjQbcc88Wj58h55TdZZaEwuAMHOXUB8dNg=
Message-ID: <4AA4D706.9030400@gmail.com>
Date: Mon, 07 Sep 2009 17:48:54 +0800
From: Xiangfu Liu <xiangfu.z@gmail.com>
Organization: openmobilefree.net (PI project)
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "Hard- and Software Development, Kernel, Distribution, Roadmap" 
	<developer@lists.qi-hardware.com>
Subject: need help on lcd driver.
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
there is something wrong with our lcd driver.
I don't know how to fix this. you can see the picture[1]
the pixels not in line. and the color also not correct.

here is our source code is at [2]
thanks for any advice


[1] http://www.openmobilefree.net/other/file/lcm_pixels.jpg
[2] http://projects.qi-hardware.com/index.php/p/openwrt-xburst/source/tree/xburst/target/linux/xburst/patches-2.6.31

--
Best Regards
Xiangfu
Email: xiangfu at qi-hardware dot com
Web: http://www.qi-hardware.com
