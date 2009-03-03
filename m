Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbZCCWED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbZCCWED (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 17:04:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755177AbZCCWAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 17:00:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39342 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758119AbZCCV74 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 16:59:56 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Randy Dunlap" <randy.dunlap@oracle.com>
References: <KiHv0irKPzE.A.l3.hUarJB@chimera>
In-Reply-To: <KiHv0irKPzE.A.l3.hUarJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SLCXkuHtxAO.A.i-C.bVarJB@chimera>
Subject: [Bug #12671] uvc_status_cleanup(): undefined reference to `input_unregister_device'
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  3 Mar 2009 20:25:54 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12671
Subject		: uvc_status_cleanup(): undefined reference to `input_unregister_device'
Submitter	: Ingo Molnar <mingo@elte.hu>
Date		: 2009-02-08 14:58 (24 days old)
References	: http://marc.info/?l=linux-kernel&m=123410529909318&w=4
Handled-By	: Randy Dunlap <randy.dunlap@oracle.com>
Patch		: http://lkml.org/lkml/2009/2/15/172


