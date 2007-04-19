Return-Path: <linux-kernel-owner+w=401wt.eu-S1766794AbXDSPNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766794AbXDSPNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 11:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766810AbXDSPNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 11:13:45 -0400
Received: from mail32.syd.optusnet.com.au ([211.29.132.63]:41721 "EHLO
	mail32.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766794AbXDSPNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 11:13:45 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>, Al Boldi <a1426z@gawab.com>,
       Peter Williams <pwil3058@bigpond.net.au>, Nick Piggin <npiggin@suse.de>,
       Matt Mackall <mpm@selenic.com>, Bill Huey <billh@gnuppy.monkey.org>,
       William Lee Irwin III <wli@holomorphy.com>, Willy Tarreau <w@1wt.eu>,
       Gene Heskett <gene.heskett@gmail.com>
Subject: [ANNOUNCE] Staircase Deadline cpu scheduler version 0.43
Date: Fri, 20 Apr 2007 01:12:35 +1000
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704200112.36465.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In order to keep raising the standard for comparison for the alternative new 
scheduler developments, here is an updated version of the staircase deadline 
cpu scheduler.

http://ck.kolivas.org/patches/staircase-deadline/2.6.20.7-sd-0.43.patch
http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc7-sd-0.43.patch

Incrementals in
http://ck.kolivas.org/patches/staircase-deadline/2.6.20.7/
http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc7/

Renicing X to -10, while not essential, is preferable.

See the 3 patches just posted for full changelog of 0.42-0.43.

-- 
-ck
