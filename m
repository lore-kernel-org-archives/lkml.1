Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935178Ab0BZL03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 06:26:29 -0500
Received: from home.kolivas.org ([59.167.196.135]:43406 "EHLO home.kolivas.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935068Ab0BZL02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 06:26:28 -0500
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Feb 2010 06:26:28 EST
From: Con Kolivas <kernel@kolivas.org>
To: LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: BFS cpu scheduler v0.315 for 2.6.33
Date: Fri, 26 Feb 2010 22:26:27 +1100
User-Agent: KMail/1.12.4 (Linux/2.6.33-ck1; KDE/4.3.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002262226.27337.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BFS cpu scheduler designed for optimum desktop performance is now 
available for 2.6.33:

http://ck.kolivas.org/patches/bfs/2.6.33-sched-bfs-315.patch

It is almost unchanged from the previous versions apart from a miniscule tweak 
to sched yield to improve performance of games that use sched yield when under 
load.

-- 
-ck
