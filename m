Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbZHBWDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbZHBWDn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 18:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbZHBWDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 18:03:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38134 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666AbZHBWDD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 18:03:03 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Hellstrom" <thellstrom@vmware.com>,
       "venkatesh.pallipadi@intel.com" <venkatesh.pallipadi@intel.com>
References: <upey9ZSfnaF.A.-oE.rpgdKB@chimera>
In-Reply-To: <upey9ZSfnaF.A.-oE.rpgdKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <7ixSg7D88bK.A.fHF.1pgdKB@chimera>
Subject: [Bug #13884] x86 CPA incorrect memtype reserving using set_pages_array_xx
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  2 Aug 2009 21:09:34 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13884
Subject		: x86 CPA incorrect memtype reserving using set_pages_array_xx
Submitter	: Thomas Hellstrom <thellstrom@vmware.com>
Date		: 2009-07-31 13:39 (3 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9ae2847591c857bed44bc094b908b412bfa1b244
Handled-By	: Thomas Hellstrom <thellstrom@vmware.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=22552


