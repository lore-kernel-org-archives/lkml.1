Return-Path: <linux-kernel-owner+w=401wt.eu-S1759882AbZDFWT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759882AbZDFWT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 18:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755064AbZDFWTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 18:19:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50131 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081AbZDFWTs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 18:19:48 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Markus" <M4rkusXXL@web.de>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
In-Reply-To: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <AsKNxFx2juN.A.wI.YGn2JB@chimera>
Subject: [Bug #12872] pwc mmap always fails with EAGAIN
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon,  6 Apr 2009 21:05:40 +0200 (CEST)
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
Date		: 2009-03-14 16:42 (24 days old)
References	: http://marc.info/?l=linux-kernel&m=123704902201378&w=4


