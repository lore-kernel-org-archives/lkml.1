Return-Path: <linux-kernel-owner+w=401wt.eu-S1755198AbZJAXKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbZJAXKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755089AbZJAXKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:10:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57471 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315AbZJAXJ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:09:59 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Michael Ellerman" <michael@ellerman.id.au>,
       "Tetsuo Handa" <penguin-kernel@i-love.sakura.ne.jp>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
In-Reply-To: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <COE24pZSBH.A.Vk.6MTxKB@chimera>
Subject: [Bug #14258] Memory leak in SCSI initialization
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu,  1 Oct 2009 21:56:02 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.30 and 2.6.31.

The following bug entry is on the current list of known regressions
introduced between 2.6.30 and 2.6.31.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14258
Subject		: Memory leak in SCSI initialization
Submitter	: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Date		: 2009-09-22 4:18 (10 days old)
References	: http://marc.info/?l=linux-kernel&m=125359311312243&w=4
Handled-By	: Michael Ellerman <michael@ellerman.id.au>
Patch		: http://patchwork.kernel.org/patch/49258/


