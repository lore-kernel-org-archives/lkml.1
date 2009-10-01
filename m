Return-Path: <linux-kernel-owner+w=401wt.eu-S1754277AbZJAWvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbZJAWvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 18:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbZJAWvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 18:51:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57195 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092AbZJAWuP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 18:50:15 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Markus Trippelsdorf" <markus@trippelsdorf.de>,
       "Theodore Tso" <tytso@mit.edu>
References: <9UCePxij8cB.A.VCG.-3SxKB@chimera>
In-Reply-To: <9UCePxij8cB.A.VCG.-3SxKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Q3xT3CnoTGE.A.ASG.D4SxKB@chimera>
Subject: [Bug #14300] BUG_ON crash w/ ext4
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu,  1 Oct 2009 21:38:47 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14300
Subject		: BUG_ON crash w/ ext4
Submitter	: Markus Trippelsdorf <markus@trippelsdorf.de>
Date		: 2009-10-01 1:41 (1 days old)
References	: http://marc.info/?l=linux-kernel&m=125436130800340&w=4
		  http://marc.info/?l=linux-kernel&m=125436568504914&w=4
Handled-By	: Theodore Tso <tytso@mit.edu>
Patch		: http://patchwork.kernel.org/patch/50810/


