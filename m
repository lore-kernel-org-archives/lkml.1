Return-Path: <linux-kernel-owner+w=401wt.eu-S1760495AbZF2Ap0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760495AbZF2Ap0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 20:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759449AbZF2Ahh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 20:37:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38780 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759463AbZF2Ahf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 20:37:35 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrea Righi" <righi.andrea@gmail.com>,
       "Dave Jones" <davej@redhat.com>, "Jarek Poplawski" <jarkao2@gmail.com>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
In-Reply-To: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <5Hhc7UkUKEO.A.3OF.JjASKB@chimera>
Subject: [Bug #13647] fb/mmap lockdep report.
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 29 Jun 2009 02:31:02 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13647
Subject		: fb/mmap lockdep report.
Submitter	: Dave Jones <davej@redhat.com>
Date		: 2009-06-21 13:33 (8 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=513adb58685615b0b1d47a3f0d40f5352beff189
References	: http://lkml.org/lkml/2009/6/21/90
		  http://lkml.org/lkml/2009/6/21/122


