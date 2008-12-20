Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbYLUAMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbYLUAMx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 19:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178AbYLUAKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 19:10:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49910 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755172AbYLUAKZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 19:10:25 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Arthur Jones" <ajones@riverbed.com>, "C Sights" <csights@fastmail.fm>,
       "Eric Sandeen" <sandeen@redhat.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Theodore Tso" <tytso@mit.edu>
References: <vYigq6XkyUN.A.E1H.7ZYTJB@chimera>
In-Reply-To: <vYigq6XkyUN.A.E1H.7ZYTJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vy-yJy0f3YP.A.Ki.OaYTJB@chimera>
Subject: [Bug #12224] journal activity on inactive partition causes inactive harddrive spinup
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 20 Dec 2008 23:00:06 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12224
Subject		: journal activity on inactive partition causes inactive harddrive spinup
Submitter	: C Sights <csights@fastmail.fm>
Date		: 2008-12-14 11:39 (7 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c87591b719737b4e91eb1a9fa8fd55a4ff1886d6
Handled-By	: Eric Sandeen <sandeen@redhat.com>


