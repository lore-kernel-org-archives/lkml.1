Return-Path: <linux-kernel-owner+w=401wt.eu-S1753012AbZJKW0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbZJKW0F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 18:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbZJKW0C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 18:26:02 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57843 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860AbZJKWZ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 18:25:58 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "Miles Lane" <miles.lane@gmail.com>
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
In-Reply-To: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <r-4Wjt4coy.A.diD.pal0KB@chimera>
Subject: [Bug #14353] BUG: sleeping function called from invalid context at kernel/mutex.c:280
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 12 Oct 2009 00:22:02 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14353
Subject		: BUG: sleeping function called from invalid context at kernel/mutex.c:280
Submitter	: Miles Lane <miles.lane@gmail.com>
Date		: 2009-10-05 3:39 (7 days old)
References	: http://marc.info/?l=linux-kernel&m=125471432208671&w=4


