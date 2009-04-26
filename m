Return-Path: <linux-kernel-owner+w=401wt.eu-S1757626AbZDZMie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626AbZDZMie (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 08:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756402AbZDZMdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 08:33:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43849 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755276AbZDZMde convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 08:33:34 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andreas Herrmann" <andreas.herrmann3@amd.com>,
       "Daniel Vetter" <daniel@ffwll.ch>
References: <tur5OtdUm3E.A.r2B.7oE9JB@chimera>
In-Reply-To: <tur5OtdUm3E.A.r2B.7oE9JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <egHshlwQQFE.A.TQD.xpE9JB@chimera>
Subject: [Bug #12961] Kernel panics in early boot: IO-APIC + timer doesn't work
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Apr 2009 11:46:27 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.28 and 2.6.29.

The following bug entry is on the current list of known regressions
introduced between 2.6.28 and 2.6.29.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12961
Subject		: Kernel panics in early boot: IO-APIC + timer doesn't work
Submitter	: Daniel Vetter <daniel@ffwll.ch>
Date		: 2009-03-28 19:00 (30 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8d6f0c8214928f7c5083dd54ecb69c5d615b516e
Handled-By	: Andreas Herrmann <andreas.herrmann3@amd.com>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=21070


