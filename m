Return-Path: <linux-kernel-owner+w=401wt.eu-S1762542AbZATAAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762542AbZATAAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760872AbZASXxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 18:53:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40360 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760865AbZASXxL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 18:53:11 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Bryan Donlan" <bdonlan@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Nick Piggin" <npiggin@suse.de>
References: <0GOi9pntEoL.A.iGF.B9QdJB@chimera>
In-Reply-To: <0GOi9pntEoL.A.iGF.B9QdJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <2QN7KFic7LG.A.fgG.b9QdJB@chimera>
Subject: [Bug #12498] OOPS and panic on 2.6.29-rc1 on xen-x86
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 19 Jan 2009 22:32:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12498
Subject		: OOPS and panic on 2.6.29-rc1 on xen-x86
Submitter	: Bryan Donlan <bdonlan@gmail.com>
Date		: 2009-01-12 17:26 (8 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e97a630eb0f5b8b380fd67504de6cedebb489003
References	: http://marc.info/?l=linux-kernel&m=123178178029065&w=4
Handled-By	: Nick Piggin <npiggin@suse.de>


