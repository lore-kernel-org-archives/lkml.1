Return-Path: <linux-kernel-owner+w=401wt.eu-S1756178AbYKPTm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbYKPTm3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 14:42:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbYKPTkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 14:40:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43417 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117AbYKPTkL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 14:40:11 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Soeren Sonnenburg" <kernel@nn7.de>
References: <1ScKicKnTUE.A.VxH.DIHIJB@chimera>
In-Reply-To: <1ScKicKnTUE.A.VxH.DIHIJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <NjF0-fuClJC.A.xFB.yIHIJB@chimera>
Subject: [Bug #11698] 2.6.27-rc7, freezes with &gt; 1 s2ram cycle
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 16 Nov 2008 18:40:57 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.26 and 2.6.27.

The following bug entry is on the current list of known regressions
introduced between 2.6.26 and 2.6.27.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11698
Subject		: 2.6.27-rc7, freezes with &gt; 1 s2ram cycle
Submitter	: Soeren Sonnenburg <kernel@nn7.de>
Date		: 2008-09-29 11:29 (49 days old)
References	: http://marc.info/?l=linux-kernel&m=122268780926859&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>


