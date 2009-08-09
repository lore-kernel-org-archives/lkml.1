Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbZHJAOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbZHJAOI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 20:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbZHJAFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 20:05:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44089 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624AbZHJAFL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 20:05:11 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Cijoml Cijomlovic Cijomlov" <cijoml@volny.cz>
References: <YCu3FOC0QrC.A.MaE.RD2fKB@chimera>
In-Reply-To: <YCu3FOC0QrC.A.MaE.RD2fKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <pRuaDVjxFBG.A.GYF.jE2fKB@chimera>
Subject: [Bug #13558] Tracelog during resume
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  9 Aug 2009 23:10:23 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13558
Subject		: Tracelog during resume
Submitter	: Cijoml Cijomlovic Cijomlov <cijoml@volny.cz>
Date		: 2009-06-17 11:32 (54 days old)


