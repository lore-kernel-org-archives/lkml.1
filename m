Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbYLDAr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbYLDAr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:47:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757112AbYLDApN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:45:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48769 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757062AbYLDApL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:45:11 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "roger" <rogerx@sdf.lonestar.org>
References: <49ZBswjGjrL.A.ECE.BGyNJB@chimera>
In-Reply-To: <49ZBswjGjrL.A.ECE.BGyNJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <TpbYvO5GPt.A.8GF.cGyNJB@chimera>
Subject: [Bug #11865] WOL for E100 Doesn't Work Anymore
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  3 Dec 2008 23:40:30 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.26 and 2.6.27.

The following bug entry is on the current list of known regressions
introduced between 2.6.26 and 2.6.27.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11865
Subject		: WOL for E100 Doesn't Work Anymore
Submitter	: roger <rogerx@sdf.lonestar.org>
Date		: 2008-10-26 21:56 (39 days old)
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=18646&action=view


