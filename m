Return-Path: <linux-kernel-owner+w=401wt.eu-S1756386AbZAKODb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbZAKODb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 09:03:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754884AbZAKN6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 08:58:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36839 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754822AbZAKN6X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 08:58:23 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Arthur Jones" <ajones@riverbed.com>, "C Sights" <csights@fastmail.fm>,
       "Eric Sandeen" <sandeen@redhat.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Theodore Tso" <tytso@mit.edu>
References: <nn3SOLVZ28H.A.bY.CafaJB@chimera>
In-Reply-To: <nn3SOLVZ28H.A.bY.CafaJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <nHCfeC0YLrE.A.7zC.FbfaJB@chimera>
Subject: [Bug #12224] journal activity on inactive partition causes inactive harddrive spinup
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 Jan 2009 12:41:02 +0100 (CET)
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
Date		: 2008-12-14 11:39 (29 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c87591b719737b4e91eb1a9fa8fd55a4ff1886d6
Handled-By	: Eric Sandeen <sandeen@redhat.com>


