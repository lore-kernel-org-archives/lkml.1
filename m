Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbZJAXIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbZJAXIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420AbZJAXIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:08:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57395 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754694AbZJAXIp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:08:45 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Eric Paris" <eparis@parisplace.org>,
       "Grant Wilson" <grant.wilson@zen.co.uk>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
In-Reply-To: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <COE24pZSBH.A.CTC.zNTxKB@chimera>
Subject: [Bug #14058] Oops in fsnotify
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu,  1 Oct 2009 21:55:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.30 and 2.6.31.

The following bug entry is on the current list of known regressions
introduced between 2.6.30 and 2.6.31.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14058
Subject		: Oops in fsnotify
Submitter	: Grant Wilson <grant.wilson@zen.co.uk>
Date		: 2009-08-20 15:48 (43 days old)
References	: http://marc.info/?l=linux-kernel&m=125078450923133&w=4


