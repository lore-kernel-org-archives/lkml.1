Return-Path: <linux-kernel-owner+w=401wt.eu-S1761925AbZASX7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761925AbZASX7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 18:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756716AbZASXxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 18:53:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40350 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760841AbZASXxG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 18:53:06 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <0GOi9pntEoL.A.iGF.B9QdJB@chimera>
In-Reply-To: <0GOi9pntEoL.A.iGF.B9QdJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <2QN7KFic7LG.A.TwG.f9QdJB@chimera>
Subject: [Bug #12496] swsusp cannot find resume device (sometimes)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 19 Jan 2009 22:32:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12496
Subject		: swsusp cannot find resume device (sometimes)
Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
Date		: 2009-01-09 12:24 (11 days old)
References	: http://marc.info/?l=linux-kernel&m=123150395731165&w=4
Handled-By	: Arjan van de Ven <arjan@infradead.org>
Patch		: http://marc.info/?l=linux-kernel&m=123156441218358&w=4
		  http://marc.info/?t=123156453100002&r=1&w=4


