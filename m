Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562AbZJAXKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbZJAXKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755542AbZJAXKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:10:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57503 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755358AbZJAXKd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:10:33 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Chris Mason" <chris.mason@oracle.com>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Dave Chinner" <david@fromorbit.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Richard Kennedy" <richard@rsk.demon.co.uk>,
       "Shaohua Li" <shaohua.li@intel.com>, "Theodore Tso" <tytso@mit.edu>,
       "Wu Fengguang" <fengguang.wu@intel.com>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
In-Reply-To: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <COE24pZSBH.A.-J.0MTxKB@chimera>
Subject: [Bug #14266] regression in page writeback
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu,  1 Oct 2009 21:56:04 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.30 and 2.6.31.

The following bug entry is on the current list of known regressions
introduced between 2.6.30 and 2.6.31.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14266
Subject		: regression in page writeback
Submitter	: Shaohua Li <shaohua.li@intel.com>
Date		: 2009-09-22 5:49 (10 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d7831a0bdf06b9f722b947bb0c205ff7d77cebd8
References	: http://marc.info/?l=linux-kernel&m=125359858117176&w=4
Handled-By	: Wu Fengguang <fengguang.wu@intel.com>


