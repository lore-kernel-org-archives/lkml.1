Return-Path: <linux-kernel-owner+w=401wt.eu-S1755117AbZKPW4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbZKPW4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:56:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965AbZKPWy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:54:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60285 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754865AbZKPWyX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:54:23 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "=?utf-8?q?Rog=C3=A9rio=20Brito?=" <rbrito@ime.usp.br>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
In-Reply-To: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <xXQGFmujPl.A.SJG.7SdALB@chimera>
Subject: [Bug #14620] WARNING: at mm/page_alloc.c:1805 __alloc_pages_nodemask
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 16 Nov 2009 23:37:47 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14620
Subject		: WARNING: at mm/page_alloc.c:1805 __alloc_pages_nodemask
Submitter	: Rogério Brito <rbrito@ime.usp.br>
Date		: 2009-11-06 23:10 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=125754907413892&w=4


