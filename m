Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbZKPUeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbZKPUeq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 15:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZKPUeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 15:34:46 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:52265 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752177AbZKPUep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 15:34:45 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArEEAIpGAUtGGN1W/2dsb2JhbACBTtVphDwEgW0
Date: Mon, 16 Nov 2009 15:34:47 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Josh Triplett <josh@joshtriplett.org>, Jon Bernard <jbernard@debian.org>,
       Jan Blunck <jblunck@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Pierre Habouzit <madcoder@debian.org>,
       Steven Munroe <munroesj@linux.vnet.ibm.com>,
       Bert Wesarg <bert.wesarg@googlemail.com>,
       Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>
Cc: ltt-dev@lists.casi.polymtl.ca, rp@svcs.cs.pdx.edu,
       linux-kernel@vger.kernel.org
Subject: [RELEASE] Userspace RCU 0.3.1
Message-ID: <20091116203447.GB19798@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 15:32:10 up 90 days,  7:21,  4 users,  load average: 0.19, 0.19,
	0.18
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I announce that Userspace RCU 0.3.1 now supports 32-bit build for
sparcv9. It updates the build system to use --host instead of --target,
which is the appropriate semantic for cross-builds.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
