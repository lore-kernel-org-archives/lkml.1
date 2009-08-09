Return-Path: <linux-kernel-owner+w=401wt.eu-S1754373AbZHIXju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbZHIXju (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 19:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbZHIXjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 19:39:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43907 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754255AbZHIXjq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 19:39:46 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "=?utf-8?q?Bruno=20Pr=C3=A9mont?=" <bonbons@linux-vserver.org>
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera>
In-Reply-To: <AuPdDySr74O.A.5LC.Pj1fKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <u1L1PAbl8zG.A.rRC.Tj1fKB@chimera>
Subject: [Bug #13950] Oops when USB Serial disconnected while in use
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  9 Aug 2009 22:44:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13950
Subject		: Oops when USB Serial disconnected while in use
Submitter	: Bruno Prémont <bonbons@linux-vserver.org>
Date		: 2009-08-08 17:47 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=124975432900466&w=4


