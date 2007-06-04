Return-Path: <linux-kernel-owner+w=401wt.eu-S1758610AbXFDV4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610AbXFDV4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 17:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbXFDV4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 17:56:07 -0400
Received: from mail.tmr.com ([64.65.253.246]:40506 "EHLO posidon.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917AbXFDV4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 17:56:06 -0400
Message-ID: <46648A72.8010401@tmr.com>
Date: Mon, 04 Jun 2007 17:56:02 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: glitch1 results - 2.6.21.3-cfs-v15
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have added cfs15 to the chart at 
www.tmr.com/~davidsen/sched_smooth_05.html and updated the source of the 
test at www.tmr.com/~public/source if anyone wants to run test on their 
hardware.

I feel that on my hardware cfs-13 was the smoothest for this test and 
for watching videos. Even relatively light load:
   nice -10 make -j4 -s
of a kernel would cause jumps on the video, gears or youtube.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
