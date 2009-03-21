Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbZCUTY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbZCUTY5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 15:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbZCUTTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 15:19:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51922 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755379AbZCUTTa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 15:19:30 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Markus" <M4rkusXXL@web.de>
References: <GPBuLTara4J.A.3kH.TZTxJB@chimera>
In-Reply-To: <GPBuLTara4J.A.3kH.TZTxJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <l8NZ2a3iQtG.A._5H.fZTxJB@chimera>
Subject: [Bug #12872] pwc mmap always fails with EAGAIN
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 21 Mar 2009 17:39:08 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12872
Subject		: pwc mmap always fails with EAGAIN
Submitter	: Markus <M4rkusXXL@web.de>
Date		: 2009-03-14 16:42 (8 days old)
References	: http://marc.info/?l=linux-kernel&m=123704902201378&w=4


