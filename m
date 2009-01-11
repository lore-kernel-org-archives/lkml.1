Return-Path: <linux-kernel-owner+w=401wt.eu-S1754282AbZAKNec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbZAKNec (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 08:34:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbZAKNdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 08:33:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36623 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbZAKNdG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 08:33:06 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dirk Hohndel" <hohndel@infradead.org>
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera>
In-Reply-To: <XU-8icArWLM.A.UpG.8GfaJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <oWTznAnH9BI.A.1M.YHfaJB@chimera>
Subject: [Bug #12400] git-latest: kernel oops in IOMMU setup
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 Jan 2009 12:16:27 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12400
Subject		: git-latest: kernel oops in IOMMU setup
Submitter	: Dirk Hohndel <hohndel@infradead.org>
Date		: 2009-01-08 20:05 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=123144520124853&w=4
Handled-By	: Dirk Hohndel <hohndel@infradead.org>
Patch		: http://marc.info/?l=linux-kernel&m=123152033725557&w=4


