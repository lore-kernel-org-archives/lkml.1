Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab0CBMFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 07:05:50 -0500
Received: from www.tglx.de ([62.245.132.106]:43048 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123Ab0CBMFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 07:05:49 -0500
Date: Tue, 2 Mar 2010 13:04:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: bugzilla-daemon@bugzilla.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       =?ISO-8859-15?Q?Asbj=F8rn_Sannes?= <kernelbugzilla@sannes.org>,
       Venkatesch Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [Bug 15289] Regression 2.6.32 -> 2.6.33, Kernel needs a helping
 key to boot :)
In-Reply-To: <alpine.LFD.2.00.1003012114470.4245@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1003021302360.4245@localhost.localdomain>
References: <bug-15289-10028@http.bugzilla.kernel.org/> <201003010617.o216HBix024914@demeter.kernel.org> <201003012103.00609.rjw@sisk.pl> <alpine.LFD.2.00.1003012114470.4245@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-377522668-1267531460=:4245"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-377522668-1267531460=:4245
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

Asbjørn,

can you please run the following tests and report the results ?

1) Add "maxcpus=1" to the kernel command line

2) Add "nomsi" to the kernel command line

Thanks,

	tglx
--8323328-377522668-1267531460=:4245--
