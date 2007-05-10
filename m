Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbXEJBX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbXEJBX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 21:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbXEJBXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 21:23:48 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:49544 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667AbXEJBXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 21:23:47 -0400
X-Greylist: delayed 1222 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 May 2007 21:23:47 EDT
Message-Id: <20070510005935.850493440@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 09 May 2007 20:59:35 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ak@suse.de
Subject: [patch 0/1] Fix default_do_nmi on x86_64 in 2.6.21-mm2
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 10 May 2007 01:02:47 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

I guess it's the expected behavior for default_do_nmi on x86_64 : there is a new
case tested in the -mm tree but it lacks the appropriate return.

It applies at the end of the 2.6.21-mm2 patch series.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
