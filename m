Return-Path: <linux-kernel-owner+w=401wt.eu-S1753741Ab0AXWmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab0AXWmr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 17:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030Ab0AXWgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 17:36:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45825 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481Ab0AXWgR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 17:36:17 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Stephen R. van den Berg" <srb@cuci.nl>,
       "Trond Myklebust" <Trond.Myklebust@netapp.com>
References: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
In-Reply-To: <pYFNu11z2aM.A.pJH.CZMXLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <q60Z28d_9yH.A.d1.0ZMXLB@chimera>
Subject: [Bug #14891] Deadlock regression related to NFS root
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 24 Jan 2010 23:23:02 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14891
Subject		: Deadlock regression related to NFS root
Submitter	: Stephen R. van den Berg <srb@cuci.nl>
Date		: 2009-11-24 0:24 (62 days old)
References	: http://marc.info/?l=linux-kernel&m=125902279909452&w=4
Handled-By	: Trond Myklebust <Trond.Myklebust@netapp.com>


