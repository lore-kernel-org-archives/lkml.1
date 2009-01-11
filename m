Return-Path: <linux-kernel-owner+w=401wt.eu-S1755642AbZAKOAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbZAKOAw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 09:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbZAKN6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 08:58:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36828 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739AbZAKN6T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 08:58:19 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dave Airlie" <airlied@redhat.com>,
       "=?utf-8?q?Fran=C3=A7ois=20Valenduc?=" 
	<francois.valenduc@tvcablenet.be>,
       "Keith Packard" <keithp@keithp.com>
References: <nn3SOLVZ28H.A.bY.CafaJB@chimera>
In-Reply-To: <nn3SOLVZ28H.A.bY.CafaJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <nHCfeC0YLrE.A.35C.HbfaJB@chimera>
Subject: [Bug #12216] Error when drm is loaded
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 Jan 2009 12:41:02 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12216
Subject		: Error when drm is loaded
Submitter	: François Valenduc <francois.valenduc@tvcablenet.be>
Date		: 2008-12-13 09:59 (30 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=52440211dcdc52c0b757f8b34d122e11b12cdd50


