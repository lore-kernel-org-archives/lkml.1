Return-Path: <linux-kernel-owner+w=401wt.eu-S1761151AbZE3WzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761151AbZE3WzS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 18:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758706AbZE3Wxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 18:53:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46770 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758541AbZE3Wxx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 18:53:53 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Daniel Bierstedt" <daniel.bierstedt@gmx.de>
References: <THxQaUP0K2D.A.QkF.UVbIKB@chimera>
In-Reply-To: <THxQaUP0K2D.A.QkF.UVbIKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <PkPeJtNB3KO.A.Z3G.BWbIKB@chimera>
Subject: [Bug #13072] forcedeth seems to switch off eth on shutdown
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 30 May 2009 21:55:36 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.28 and 2.6.29.

The following bug entry is on the current list of known regressions
introduced between 2.6.28 and 2.6.29.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13072
Subject		: forcedeth seems to switch off eth on shutdown
Submitter	: Daniel Bierstedt <daniel.bierstedt@gmx.de>
Date		: 2009-04-12 07:00 (49 days old)


