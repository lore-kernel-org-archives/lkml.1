Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253Ab0AJXMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab0AJXMe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 18:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755215Ab0AJXMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 18:12:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58181 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793Ab0AJXEE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 18:04:04 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "christian hartmann" <cornogle@googlemail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Justin Mattock" <justinmattock@gmail.com>,
       "Len Brown" <len.brown@intel.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Martin Schwidefsky" <schwidefsky@de.ibm.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Xiaotian Feng" <dfeng@redhat.com>
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera>
In-Reply-To: <nzLqtSp97aP.A.RGB.hglSLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <CXIfLt-ygXM.A.MGE.wilSLB@chimera>
Subject: [Bug #14483] Interrupts enabled after irqrouter_resume - iMac9,1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Jan 2010 23:56:11 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14483
Subject		: Interrupts enabled after irqrouter_resume - iMac9,1
Submitter	: Justin Mattock <justinmattock@gmail.com>
Date		: 2009-10-25 19:58 (78 days old)
References	: http://marc.info/?l=linux-kernel&m=125650070420168&w=4
Handled-By	: Xiaotian Feng <dfeng@redhat.com>
Patch		: http://patchwork.kernel.org/patch/64771/


