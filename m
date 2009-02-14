Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbZBNXIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbZBNXIz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 18:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755231AbZBNXGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 18:06:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44544 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755219AbZBNXGl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 18:06:41 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera>
In-Reply-To: <juADNmcceYF.A.mdD.Mr0lJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <rjPbZ5GRJPO.A.6RG.6s0lJB@chimera>
Subject: [Bug #12496] swsusp cannot find resume device (sometimes)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Feb 2009 21:38:16 +0100 (CET)
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
Date		: 2009-01-09 12:24 (37 days old)
References	: http://marc.info/?l=linux-kernel&m=123150395731165&w=4
Handled-By	: Arjan van de Ven <arjan@infradead.org>
Patch		: http://marc.info/?l=linux-kernel&m=123156441218358&w=4
		  http://marc.info/?t=123156453100002&r=1&w=4


