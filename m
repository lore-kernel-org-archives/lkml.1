Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951AbZHSXia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbZHSXia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 19:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbZHSXiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 19:38:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34408 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753900AbZHSXiW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 19:38:22 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Diego Calleja" <diegocg@gmail.com>
References: <xDf-7eSwYsC.A.-6B.klIjKB@chimera>
In-Reply-To: <xDf-7eSwYsC.A.-6B.klIjKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Era7U-todKF.A.7AD.PnIjKB@chimera>
Subject: [Bug #13408] Performance regression in 2.6.30-rc7
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 19 Aug 2009 22:40:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13408
Subject		: Performance regression in 2.6.30-rc7
Submitter	: Diego Calleja <diegocg@gmail.com>
Date		: 2009-05-30 18:51 (82 days old)
References	: http://lkml.org/lkml/2009/5/30/146


