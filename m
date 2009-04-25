Return-Path: <linux-kernel-owner+w=401wt.eu-S1758391AbZDYWZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758391AbZDYWZ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 18:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756593AbZDYWUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 18:20:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41710 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756569AbZDYWUE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 18:20:04 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dave Hansen" <dave@sr71.net>, "john stultz" <johnstul@us.ibm.com>,
       "Len Brown" <lenb@kernel.org>
References: <47KgT3nlbjD.A.lnB.jc48JB@chimera>
In-Reply-To: <47KgT3nlbjD.A.lnB.jc48JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Fg2zLW93smL.A.A9C.6c48JB@chimera>
Subject: [Bug #13164] 2.6.30-rc2 soft lockups: ACPI?  clock source problem?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 25 Apr 2009 21:31:49 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13164
Subject		: 2.6.30-rc2 soft lockups: ACPI?  clock source problem?
Submitter	: Dave Hansen <dave@sr71.net>
Date		: 2009-04-21 17:30 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=124033550127455&w=4
Handled-By	: john stultz <johnstul@us.ibm.com>
		  Len Brown <lenb@kernel.org>


