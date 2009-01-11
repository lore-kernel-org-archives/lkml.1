Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbZAKOEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbZAKOEP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 09:04:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbZAKN6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 08:58:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36842 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754800AbZAKN6W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 08:58:22 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alberto Gonzalez" <luis6674@yahoo.com>
References: <nn3SOLVZ28H.A.bY.CafaJB@chimera>
In-Reply-To: <nn3SOLVZ28H.A.bY.CafaJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <nHCfeC0YLrE.A.AOC.uafaJB@chimera>
Subject: [Bug #12337] ~100 extra wakeups reported by powertop
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 Jan 2009 12:41:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12337
Subject		: ~100 extra wakeups reported by powertop
Submitter	: Alberto Gonzalez <luis6674@yahoo.com>
Date		: 2008-12-31 12:25 (12 days old)


