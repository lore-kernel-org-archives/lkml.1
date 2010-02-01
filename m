Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab0BABBl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 20:01:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50712 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471Ab0BAA76 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 19:59:58 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "=?utf-8?q?Fran=C3=A7ois=20Figarola?=" 
	<francois.figarola@i-consult.fr>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera>
In-Reply-To: <UgwvXSBS_tM.A.alD.1EiZLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <de962C6zBxL.A.V8D.CFiZLB@chimera>
Subject: [Bug #15135] Kernel 2.6.32.x hangs during boot process
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon,  1 Feb 2010 01:43:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15135
Subject		: Kernel 2.6.32.x hangs during boot process
Submitter	: François Figarola <francois.figarola@i-consult.fr>
Date		: 2010-01-16 9:58 (16 days old)
References	: http://marc.info/?l=linux-kernel&m=126363593817261&w=4
Handled-By	: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Patch		: http://patchwork.kernel.org/patch/75560/


