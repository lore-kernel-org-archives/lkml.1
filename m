Return-Path: <linux-kernel-owner+w=401wt.eu-S1754486AbYHPUqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbYHPUqb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 16:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbYHPUd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 16:33:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37385 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401AbYHPUdy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 16:33:54 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andi Kleen" <andi@firstfloor.org>, "Jean Delvare" <khali@linux-fr.org>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
In-Reply-To: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sNRO-BDDjQL.A.99D.9ZzpIB@albercik>
Subject: [Bug #11346] kernel BUG at arch/x86/mm/pat.c:233!
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 16 Aug 2008 21:02:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11346
Subject		: kernel BUG at arch/x86/mm/pat.c:233!
Submitter	: Jean Delvare <khali@linux-fr.org>
Date		: 2008-08-15 02:10 (2 days old)
Handled-By	: Andi Kleen <andi@firstfloor.org>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=17270&action=view


