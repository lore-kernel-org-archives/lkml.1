Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbZJAWuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbZJAWuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 18:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027AbZJAWuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 18:50:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57172 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019AbZJAWtk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 18:49:40 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Thomas Backlund" <tmb@mandriva.org>
References: <9UCePxij8cB.A.VCG.-3SxKB@chimera>
In-Reply-To: <9UCePxij8cB.A.VCG.-3SxKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Q3xT3CnoTGE.A.aRH.b4SxKB@chimera>
Subject: [Bug #14247] ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] flooding logs
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu,  1 Oct 2009 21:38:44 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14247
Subject		: ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] flooding logs
Submitter	: Thomas Backlund <tmb@mandriva.org>
Date		: 2009-09-25 15:08 (7 days old)
References	: http://lkml.org/lkml/2009/9/25/121
Handled-By	: Alexey Starikovskiy <astarikovskiy@suse.de>
Patch		: http://patchwork.kernel.org/patch/50516/


