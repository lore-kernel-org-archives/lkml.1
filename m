Return-Path: <linux-kernel-owner+w=401wt.eu-S1755061AbZG0VZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061AbZG0VZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 17:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755051AbZG0VZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 17:25:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45809 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049AbZG0VZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 17:25:18 -0400
Date: Mon, 27 Jul 2009 23:25:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: eranian@gmail.com
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: perf_counters issue with self-sampling threads
Message-ID: <20090727212514.GA25386@basil.fritz.box>
References: <7c86c4470907270951i48886d56g90bc198f26bb0716@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470907270951i48886d56g90bc198f26bb0716@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I wonder how SIGPROF gets around the same problem, or is it
buggy too?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
