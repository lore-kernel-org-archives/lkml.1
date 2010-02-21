Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab0BUVw4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 16:52:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58798 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929Ab0BUVwx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 16:52:53 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, "Jouni Malinen" <j@w1.fi>,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Michael Neuling" <mikey@neuling.org>
References: <b_eAfX__uZL.A.lvE.HcagLB@chimera>
In-Reply-To: <b_eAfX__uZL.A.lvE.HcagLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <ClJsQB_ZlxO.A.dcF.YcagLB@chimera>
Subject: [Bug #15308] 2.6.33-rc8 breaks UML with Restrict initial stack space expansion to rlimit
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 21 Feb 2010 22:30:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15308
Subject		: 2.6.33-rc8 breaks UML with Restrict initial stack space expansion to rlimit
Submitter	: Jouni Malinen <j@w1.fi>
Date		: 2010-02-14 16:40 (8 days old)
First-Bad-Commit: http://git.kernel.org/git/linus/803bf5ec259941936262d10ecc84511b76a20921
Message-ID	: <20100214164023.GA2726@jm.kir.nu>
References	: http://marc.info/?l=linux-kernel&m=126616751807902&w=4
Handled-By	: Michael Neuling <mikey@neuling.org>
Patch		: http://patchwork.kernel.org/patch/79365/


