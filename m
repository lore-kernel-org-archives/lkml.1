Return-Path: <linux-kernel-owner+w=401wt.eu-S1754963AbYKBSOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963AbYKBSOX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 13:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754794AbYKBSD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 13:03:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35759 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785AbYKBSDZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 13:03:25 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Meelis Roos" <mroos@linux.ee>, "Simon Arlott" <simon@fire.lp0.eu>,
       "Theodore Tso" <tytso@mit.edu>
References: <603i_OdVYPF.A.7_D.mjeDJB@chimera>
In-Reply-To: <603i_OdVYPF.A.7_D.mjeDJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <wOAXuecskPD.A.1OE.sjeDJB@chimera>
Subject: [Bug #11937] ext3 __log_wait_for_space: no transactions
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  2 Nov 2008 17:07:09 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11937
Subject		: ext3 __log_wait_for_space: no transactions
Submitter	: Meelis Roos <mroos@linux.ee>
Date		: 2008-10-30 9:49 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=122536026105643&w=4
Handled-By	: Theodore Tso <tytso@mit.edu>


