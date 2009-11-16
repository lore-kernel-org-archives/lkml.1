Return-Path: <linux-kernel-owner+w=401wt.eu-S1755230AbZKPW6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbZKPW6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:58:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755203AbZKPW6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:58:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60250 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754816AbZKPWxr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:53:47 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Justin P. Mattock" <justinmattock@gmail.com>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
In-Reply-To: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <xXQGFmujPl.A.CnG.JTdALB@chimera>
Subject: [Bug #14487] PANIC: early exception 08 rip 246:10 error ffffffff810251b5 cr2 0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 16 Nov 2009 23:37:45 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.31.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14487
Subject		: PANIC: early exception 08 rip 246:10 error ffffffff810251b5 cr2 0
Submitter	: Justin P. Mattock <justinmattock@gmail.com>
Date		: 2009-10-23 16:45 (25 days old)
References	: http://lkml.org/lkml/2009/10/23/252


