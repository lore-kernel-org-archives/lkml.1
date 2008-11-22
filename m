Return-Path: <linux-kernel-owner+w=401wt.eu-S1758446AbYKVWbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446AbYKVWbw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 17:31:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757460AbYKVW32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 17:29:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37712 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755925AbYKVW30 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 17:29:26 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Tomasz Chmielewski" <tch@wpkg.org>
References: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
In-Reply-To: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <vyitTh0pP2N.A.2-C.G8HKJB@chimera>
Subject: [Bug #11958] [2.6.27.x =&gt; 2.6.28-rc3] Xorg crash with xf86MapVidMem error
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 22 Nov 2008 21:28:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11958
Subject		: [2.6.27.x =&gt; 2.6.28-rc3] Xorg crash with xf86MapVidMem error
Submitter	: Tomasz Chmielewski <tch@wpkg.org>
Date		: 2008-11-05 05:37 (18 days old)


