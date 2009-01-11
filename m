Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbZAKNgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbZAKNgt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 08:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754138AbZAKNds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 08:33:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36653 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129AbZAKNdq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 08:33:46 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Daniel Drake" <dsd@gentoo.org>,
       "Jeff Chua" <jeff.chua.linux@gmail.com>,
       "Phil Dibowitz" <phil@ipom.com>
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera>
In-Reply-To: <XU-8icArWLM.A.UpG.8GfaJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <oWTznAnH9BI.A.qDH.EHfaJB@chimera>
Subject: [Bug #12422] 2.6.28-git can't resume from str
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 Jan 2009 12:16:28 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12422
Subject		: 2.6.28-git can't resume from str
Submitter	: Jeff Chua <jeff.chua.linux@gmail.com>
Date		: 2009-01-10 1:39 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=123155157909282&w=4


