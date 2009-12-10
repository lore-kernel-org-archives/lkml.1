Return-Path: <linux-kernel-owner+w=401wt.eu-S1760725AbZLJNjC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760725AbZLJNjC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 08:39:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760630AbZLJNi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 08:38:58 -0500
Received: from tomts36.bellnexxia.net ([209.226.175.93]:54940 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760622AbZLJNi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 08:38:57 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvYEAPOFIEuuWOw8/2dsb2JhbACBS9RWhCwE
Date: Thu, 10 Dec 2009 08:38:59 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jon Bernard <jbernard@debian.org>
Cc: Jan Blunck <jblunck@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       pierre-marc.fournier@polymtl.ca, ltt-dev@lists.casi.polymtl.ca,
       linux-kernel@vger.kernel.org
Subject: [RELEASE] Userspace RCU 0.3.2
Message-ID: <20091210133859.GA8690@Krystal>
References: <20091206151915.GA29729@Krystal> <20091206231026.GA5619@melvin> <20091206233622.GB5514@Krystal> <20091207030259.GB5619@melvin> <20091207032755.GA24880@Krystal> <20091207231236.GA2265@melvin> <20091208001051.GA556@Krystal> <20091208010823.GC2265@melvin> <20091208011121.GB8140@Krystal> <20091208012007.GD2265@melvin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20091208012007.GD2265@melvin>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 08:35:24 up 8 days,  4:26,  4 users,  load average: 0.54, 0.36,
	0.24
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I hereby announce the 0.3.2 release of the Userspace RCU library, which
includes a complete rework of s390/s390x uatomic_* operations.

As always, available at http://www.lttng.org/urcu

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
