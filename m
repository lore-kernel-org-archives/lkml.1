Return-Path: <linux-kernel-owner+w=401wt.eu-S1759650AbYEKVJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759650AbYEKVJT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 17:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759361AbYEKVBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 17:01:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34132 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759042AbYEKVBi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 17:01:38 -0400
Cc: "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Lee Schermerhorn" <lee.schermerhorn@hp.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Mel Gorman" <mel@csn.ul.ie>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
In-Reply-To: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <88YBFoyd1CN.A.XeH.Hw1JIB@chimera>
Subject: [Bug #10639] parisc DISCONTIGMEM compile breakage
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 May 2008 22:04:14 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10639
Subject		: parisc DISCONTIGMEM compile breakage
Submitter	: Adrian Bunk <bunk@kernel.org>
Date		: 2008-05-08 13:52 (4 days old)
Handled-By	: Mel Gorman <mel@csn.ul.ie>


