Return-Path: <linux-kernel-owner+w=401wt.eu-S1764102AbXESUCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764102AbXESUCz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 16:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759335AbXESUCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 16:02:48 -0400
Received: from pool-72-92-171-78.albyny.east.verizon.net ([72.92.171.78]:50657
	"EHLO posidon.tmr.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759307AbXESUCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 16:02:48 -0400
Message-ID: <464F57DD.2000309@tmr.com>
Date: Sat, 19 May 2007 16:02:37 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Sched - graphic smoothness under load - cfs-v13 sd-0.48
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I generated a table of results from the latest glitch1 script, using an 
HTML postprocessor I not *quite* ready to foist on the word. In any case 
it has some numbers for frames per second, fairness of the processor 
time allocated to the compute bound processes which generate a lot of 
other screen activity for X, and my subjective comments on how smooth it 
looked and felt.

The chart is at http://www.tmr.com/~davidsen/sched_smooth_01.html for 
your viewing pleasure. The only "tuned" result was with sd, since what I 
observed was so bad using the default settings. If any scheduler 
developers would like me to try other tunings or new versions let me know.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

