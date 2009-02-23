Return-Path: <linux-kernel-owner+w=401wt.eu-S1760197AbZBXAho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760197AbZBXAho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 19:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758735AbZBXAeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 19:34:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42813 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758684AbZBXAe0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 19:34:26 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Frank Groeneveld" <frankgroeneveld@gmail.com>,
       "Pavel Machek" <pavel@suse.cz>
References: <HFSEX4uppGO.A.JSG.2yzoJB@chimera>
In-Reply-To: <HFSEX4uppGO.A.JSG.2yzoJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <LLno3yT_fnC.A.tvH.rzzoJB@chimera>
Subject: [Bug #12407] Kernel 2.6.28 regression: Hang after hibernate
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 23 Feb 2009 23:03:01 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.27 and 2.6.28.

The following bug entry is on the current list of known regressions
introduced between 2.6.27 and 2.6.28.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12407
Subject		: Kernel 2.6.28 regression: Hang after hibernate
Submitter	: Frank Groeneveld <frankgroeneveld@gmail.com>
Date		: 2008-12-28 20:34 (58 days old)
References	: http://marc.info/?l=linux-kernel&m=123049651906081&w=4


