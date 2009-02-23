Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbZBWNAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbZBWNAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 08:00:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbZBWNAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 08:00:39 -0500
Received: from phunq.net ([64.81.85.152]:38380 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753582AbZBWNAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 08:00:38 -0500
From: Daniel Phillips <phillips@phunq.net>
To: linux-kernel@vger.kernel.org
Subject: Tux3 Report: Tux3 Debut at SCALE 7x
Date: Mon, 23 Feb 2009 05:00:35 -0800
User-Agent: KMail/1.9.5
Cc: linux-fsdevel@vger.kernel.org, tux3@tux3.org,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902230500.36275.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, Tux3 was presented at SCALE 7x in Los Angeles:

   http://scale7x.socallinuxexpo.org/

Slides from the presentation are here:

   http://tux3.org/docs/tux3.scale.7x.pdf

Audio will be available later (eek!).

The presentation was given on a ten year old Vaio laptop running
a completely modern Debian Sid, with XFCE, Openoffice, and one of
Linus's latest kernels from Git.  The root filesytem was Tux3:

   http://tux3.org/images/tux3.root.jpg
   
Preliminary benchmarks show Tux3 performing well, though optimization
work has not yet begun in earnest.  Many thanks to the usual cast of
characters, especially Hirofumi who continued to feed me bug fix
patches into the wee hours of Sunday morning, and Timothy Huber who
provided a wild ride to the show as well as some very slick graphics.

Tux3 did not crash.  That is good, because recovery is not fully
implemented.  However, we think it is about time to start reviewing
this code, with a view to getting an early merge.  The essential
structure is all there, and it works pretty well.  Tux3 has plenty to
offer in terms of advancing the state of the art of Linux storage,
and will best be able to offer that as part of mainline.

Tux3 source code is here:

  http://hg.tux3.org/tux3
  http://hg.tux3.org/tux3/file/3118107954f1/user/kernel/

A Git tree will appear soon, along with proper kernel patches.  But
that is for later and now is time to sleep.  It has been a long week.

Regards,

Daniel
