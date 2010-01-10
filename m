Return-Path: <linux-kernel-owner+w=401wt.eu-S1754232Ab0AJWkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab0AJWkx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 17:40:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168Ab0AJWki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 17:40:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57878 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157Ab0AJWkG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 17:40:06 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexander Beregalov" <a.beregalov@gmail.com>,
       "Frederic Weisbecker" <fweisbec@gmail.com>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
In-Reply-To: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <omZ8aBZReyD.A.vd.qNlSLB@chimera>
Subject: [Bug #14899] reiserfs: inconsistent lock state
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Jan 2010 23:32:53 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14899
Subject		: reiserfs: inconsistent lock state
Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
Date		: 2009-12-11 22:06 (31 days old)
References	: http://marc.info/?l=linux-kernel&m=126056920702515&w=4
Handled-By	: Frederic Weisbecker <fweisbec@gmail.com>
Patch		: http://patchwork.kernel.org/patch/67256/
		  http://patchwork.kernel.org/patch/67257/


