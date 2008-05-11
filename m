Return-Path: <linux-kernel-owner+w=401wt.eu-S1759655AbYEKVJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759655AbYEKVJg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 17:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759380AbYEKVBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 17:01:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34136 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759278AbYEKVBi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 17:01:38 -0400
Cc: "Adrian Bunk" <bunk@kernel.org>,
       "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
In-Reply-To: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <88YBFoyd1CN.A.9QH.Bw1JIB@chimera>
Subject: [Bug #10641] [BUG] 2.6.26-rc1-git4 - task blocked on powerpc for more than 120 seconds
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 May 2008 22:04:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10641
Subject		: [BUG] 2.6.26-rc1-git4 - task blocked on powerpc for more than 120 seconds
Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Date		: 2008-05-07 13:34 (5 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121016673607188&amp;w=2
Handled-By	: Adrian Bunk <bunk@kernel.org>


