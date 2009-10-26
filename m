Return-Path: <linux-kernel-owner+w=401wt.eu-S1755649AbZJZTIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649AbZJZTIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbZJZTFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:05:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59434 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755351AbZJZTFI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:05:08 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Feng Tang" <feng.tang@intel.com>,
       "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
In-Reply-To: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <6dRYo8ss7vL.A.7wF.Dre5KB@chimera>
Subject: [Bug #14466] EFI boot on x86 fails in .32
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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14466
Subject		: EFI boot on x86 fails in .32
Submitter	: Matthew Garrett <mjg59@srcf.ucam.org>
Date		: 2009-10-20 0:34 (7 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7bd867dfb4e0357e06a3211ab2bd0e714110def3
References	: http://marc.info/?l=linux-kernel&m=125599887314290&w=4
Handled-By	: Feng Tang <feng.tang@intel.com>


