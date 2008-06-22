Return-Path: <linux-kernel-owner+w=401wt.eu-S1760022AbYFVTQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760022AbYFVTQ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 15:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756570AbYFVTFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 15:05:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36264 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756411AbYFVTFS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 15:05:18 -0400
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Vegard Nossum" <vegard.nossum@gmail.com>
References: <RzbtSgMztjP.A.jRD._spXIB@albercik>
In-Reply-To: <RzbtSgMztjP.A.jRD._spXIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <4mRZUF-hVeG.A.I_D.YtpXIB@albercik>
Subject: [Bug #10955] v2.6.26-rc7: BUG task_struct: Poison overwritten
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 22 Jun 2008 19:54:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10955
Subject		: v2.6.26-rc7: BUG task_struct: Poison overwritten
Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
Date		: 2008-06-21 19:24 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=121407641925121&w=4
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


