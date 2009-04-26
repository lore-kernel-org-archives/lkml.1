Return-Path: <linux-kernel-owner+w=401wt.eu-S1758827AbZDZMnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827AbZDZMnS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 08:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756716AbZDZMeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 08:34:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43893 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756708AbZDZMeW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 08:34:22 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>
References: <tur5OtdUm3E.A.r2B.7oE9JB@chimera>
In-Reply-To: <tur5OtdUm3E.A.r2B.7oE9JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <egHshlwQQFE.A.X-B._oE9JB@chimera>
Subject: [Bug #13186] cpufreq timer teardown problem
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Apr 2009 11:46:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.28 and 2.6.29.

The following bug entry is on the current list of known regressions
introduced between 2.6.28 and 2.6.29.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13186
Subject		: cpufreq timer teardown problem
Submitter	: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date		: 2009-04-23 14:00 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=124049523515036&w=4
Handled-By	: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Patch		: http://patchwork.kernel.org/patch/19754/
		  http://patchwork.kernel.org/patch/19753/


