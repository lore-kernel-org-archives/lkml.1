Return-Path: <linux-kernel-owner+w=401wt.eu-S965449AbXG1BWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965449AbXG1BWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 21:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938385AbXG1BWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 21:22:14 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:17607 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933486AbXG1BWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 21:22:13 -0400
Date: Fri, 27 Jul 2007 21:20:57 -0400
From: Chris Mason <chris.mason@oracle.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] seekwatcher v0.3 IO graphing an animation
Message-ID: <20070727212057.174ef1ca@think.oraclecorp.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hello everyone,

I've tossed out seekwatcher v0.3.  The major changes are using rolling
averages to smooth out the seek and throughput graphs, and it can
generate mpgs of the IO done by a given trace.

Here's a sample of the smoother graphs (creating 20 kernel trees):

http://oss.oracle.com/~mason/seekwatcher/ext3_vs_btrfs_vs_xfs.png

There are details and sample movies of the kernel tree run at:

http://oss.oracle.com/~mason/seekwatcher

-chris
