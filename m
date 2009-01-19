Return-Path: <linux-kernel-owner+w=401wt.eu-S1760188AbZATAMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760188AbZATAMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:12:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761754AbZATAFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 19:05:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40590 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932130AbZATAFj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 19:05:39 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Arthur Jones" <ajones@riverbed.com>, "C Sights" <csights@fastmail.fm>,
       "Eric Sandeen" <sandeen@redhat.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Theodore Tso" <tytso@mit.edu>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera>
In-Reply-To: <KTnguC9mFUC.A.VNB.TJRdJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <cX2gZ6Cy9nC.A.jfD.SKRdJB@chimera>
Subject: [Bug #12224] journal activity on inactive partition causes inactive harddrive spinup
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 19 Jan 2009 22:45:38 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12224
Subject		: journal activity on inactive partition causes inactive harddrive spinup
Submitter	: C Sights <csights@fastmail.fm>
Date		: 2008-12-14 11:39 (37 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c87591b719737b4e91eb1a9fa8fd55a4ff1886d6
Handled-By	: Eric Sandeen <sandeen@redhat.com>


