Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbZBDNc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbZBDNc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 08:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757428AbZBDNZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 08:25:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45664 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712AbZBDNZq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 08:25:46 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Frederik Deweerdt" <frederik.deweerdt@xprog.eu>,
       "Tetsuo Handa" <penguin-kernel@i-love.sakura.ne.jp>
References: <a47yn9c9JrF.A.hz.L5YiJB@chimera>
In-Reply-To: <a47yn9c9JrF.A.hz.L5YiJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <CGyEB0S4BpO.A.a1B.q5YiJB@chimera>
Subject: [Bug #12409] NULL pointer dereference at get_stats()
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed,  4 Feb 2009 11:58:42 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12409
Subject		: NULL pointer dereference at get_stats()
Submitter	: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Date		: 2008-12-30 12:53 (37 days old)
References	: http://marc.info/?l=linux-kernel&m=123064167008695&w=4
Handled-By	: Frederik Deweerdt <frederik.deweerdt@xprog.eu>


