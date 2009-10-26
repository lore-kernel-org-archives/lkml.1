Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbZJZTFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbZJZTFO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755387AbZJZTFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:05:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59430 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755352AbZJZTFH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:05:07 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Christoph Lameter" <cl@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Jeff Mahoney" <jeffm@suse.com>,
       "Jiri Kosina" <jkosina@suse.cz>, "Luck, Tony" <tony.luck@intel.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Peter Zijlstra" <peterz@infradead.org>, "Tejun Heo" <tj@kernel.org>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
In-Reply-To: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <6dRYo8ss7vL.A.nnF.Cre5KB@chimera>
Subject: [Bug #14467] Linker errors on ia64 with NR_CPUS=4096
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 26 Oct 2009 19:55:57 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14467
Subject		: Linker errors on ia64 with NR_CPUS=4096
Submitter	: Jeff Mahoney <jeffm@suse.com>
Date		: 2009-10-18 22:28 (9 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=34d76c41554a05425613d16efebb3069c4c545f0
References	: http://marc.info/?l=linux-kernel&m=125590493116720&w=4


