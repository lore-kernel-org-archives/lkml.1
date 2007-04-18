Return-Path: <linux-kernel-owner+w=401wt.eu-S1030357AbXDRX61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030357AbXDRX61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 19:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030360AbXDRX61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 19:58:27 -0400
Received: from mail04.syd.optusnet.com.au ([211.29.132.185]:47020 "EHLO
	mail04.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030357AbXDRX61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 19:58:27 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>
Subject: Announce - Staircase Deadline cpu scheduler v0.41
Date: Thu, 19 Apr 2007 09:59:06 +1000
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704190959.06432.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since there is so much work currently ongoing with alternative cpu schedulers, 
as a standard for comparison with the alternative virtual deadline fair 
designs I've addressed a few issues in the Staircase Deadline cpu scheduler 
which improve behaviour likely in a noticeable fashion and released version 
0.41.

http://ck.kolivas.org/patches/staircase-deadline/2.6.20.7-sd-0.41.patch
http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc7-sd-0.41.patch

and an incremental for those on 0.40:
http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc7/sched-implement-staircase-deadline-scheduler-further-improvements.patch

Remember to renice X to -10 for nicest desktop behaviour :)

Have fun.

-- 
-ck
