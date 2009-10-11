Return-Path: <linux-kernel-owner+w=401wt.eu-S1752654AbZJKWZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbZJKWZS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 18:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbZJKWZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 18:25:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57812 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbZJKWZO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 18:25:14 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Christian Casteyde" <casteyde.christian@free.fr>,
       "Ingo Molnar" <mingo@elte.hu>, "Jan Beulich" <jbeulich@novell.com>,
       "Jan Beulich" <JBeulich@novell.com>
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
In-Reply-To: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <r-4Wjt4coy.A.WZE.Abl0KB@chimera>
Subject: [Bug #14279] Suspend to RAM freeze totally since 2.6.32-rc1 - Acer Aspire 1511Lmi laptop
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 12 Oct 2009 00:22:00 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14279
Subject		: Suspend to RAM freeze totally since 2.6.32-rc1 - Acer Aspire 1511Lmi laptop
Submitter	: Christian Casteyde <casteyde.christian@free.fr>
Date		: 2009-09-30 18:14 (12 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5f68563996e812f9ca35b3939ad2a42e5d254d66


