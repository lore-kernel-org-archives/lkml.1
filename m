Return-Path: <linux-kernel-owner+w=401wt.eu-S1757073AbZDYW3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073AbZDYW3a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 18:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756632AbZDYWU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 18:20:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41713 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755929AbZDYWUO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 18:20:14 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Rusty Russell" <rusty@rustcorp.com.au>,
       "Steven Rostedt" <rostedt@goodmis.org>
References: <47KgT3nlbjD.A.lnB.jc48JB@chimera>
In-Reply-To: <47KgT3nlbjD.A.lnB.jc48JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Fg2zLW93smL.A.vmC.zc48JB@chimera>
Subject: [Bug #13173] NULL pointer crash in early NMI handler
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 25 Apr 2009 21:31:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13173
Subject		: NULL pointer crash in early NMI handler
Submitter	: Steven Rostedt <rostedt@goodmis.org>
Date		: 2009-04-21 1:35 (5 days old)
References	: http://marc.info/?l=linux-kernel&m=124027774713368&w=4
Handled-By	: Rusty Russell <rusty@rustcorp.com.au>
Patch		: http://patchwork.kernel.org/patch/19141/
		  http://patchwork.kernel.org/patch/19140/


