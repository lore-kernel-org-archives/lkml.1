Return-Path: <linux-kernel-owner+w=401wt.eu-S1754933AbZAKOGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbZAKOGM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 09:06:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755118AbZAKN7C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 08:59:02 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36878 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754863AbZAKN7A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 08:59:00 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Kernel" <kernel@bazarnic.net>
References: <nn3SOLVZ28H.A.bY.CafaJB@chimera>
In-Reply-To: <nn3SOLVZ28H.A.bY.CafaJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <nHCfeC0YLrE.A.tkB.dafaJB@chimera>
Subject: [Bug #12404] Oops in 2.6.28-rc9 and -rc8 -- mtrr issues / e1000e
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 Jan 2009 12:41:06 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12404
Subject		: Oops in 2.6.28-rc9 and -rc8 -- mtrr issues / e1000e
Submitter	: Kernel <kernel@bazarnic.net>
Date		: 2008-12-22 9:37 (21 days old)
References	: http://marc.info/?l=linux-kernel&m=122993873320150&w=4


