Return-Path: <linux-kernel-owner+w=401wt.eu-S1757801AbZEPXAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801AbZEPXAB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 19:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756667AbZEPW7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 18:59:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44217 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755860AbZEPW7P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 18:59:15 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dave Airlie" <airlied@linux.ie>, "David Howells" <dhowells@redhat.com>,
       "DRI" <dri-devel@lists.sourceforge.net>,
       "Emil Karlson" <jkarlson@cc.hut.fi>, "Eric Anholt" <eric@anholt.net>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>
References: <yO1BmxN79sN.A.xAG.8_zDKB@chimera>
In-Reply-To: <yO1BmxN79sN.A.xAG.8_zDKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pQ9WADCjgyE.A.viH.dB0DKB@chimera>
Subject: [Bug #12861] Xorg fails to start "Failed to allocate space for kernel memory manager"
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 16 May 2009 22:05:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.28 and 2.6.29.

The following bug entry is on the current list of known regressions
introduced between 2.6.28 and 2.6.29.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12861
Subject		: Xorg fails to start "Failed to allocate space for kernel memory manager"
Submitter	: Emil Karlson <jkarlson@cc.hut.fi>
Date		: 2009-03-12 12:06 (66 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ab657db12d7020629f26f30d287558a8d0e32b41


