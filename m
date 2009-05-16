Return-Path: <linux-kernel-owner+w=401wt.eu-S1756968AbZEPW0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968AbZEPW0o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 18:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758253AbZEPWQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 18:16:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43911 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758220AbZEPWQU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 18:16:20 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jonathan Corbet" <corbet@lwn.net>,
       "Peter Zijlstra" <peterz@infradead.org>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
In-Reply-To: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <385Pu-agh7M.A.H3H.aYzDKB@chimera>
Subject: [Bug #13325] 2.6.30-rc kills my box hard - and lockdep chains
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 16 May 2009 21:20:48 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13325
Subject		: 2.6.30-rc kills my box hard - and lockdep chains
Submitter	: Jonathan Corbet <corbet@lwn.net>
Date		: 2009-05-14 15:49 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=124231630701394&w=4


