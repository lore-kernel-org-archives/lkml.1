Return-Path: <linux-kernel-owner+w=401wt.eu-S1754912AbZKPWyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbZKPWyF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:54:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbZKPWyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:54:01 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60270 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666AbZKPWxy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:53:54 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Chris Mason" <chris.mason@oracle.com>,
       "Dmitry Monakhov" <rjevskiy@gmail.com>, "Sage Weil" <sage@newdream.net>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
In-Reply-To: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <xXQGFmujPl.A.wQG.8SdALB@chimera>
Subject: [Bug #14619] ext3/jbd oops in journal_start
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 16 Nov 2009 23:37:46 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14619
Subject		: ext3/jbd oops in journal_start
Submitter	: Sage Weil <sage@newdream.net>
Date		: 2009-10-31 6:14 (17 days old)
References	: http://marc.info/?l=linux-kernel&m=125696970418300&w=4


