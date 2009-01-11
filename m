Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbZAKNf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbZAKNf7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 08:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126AbZAKNdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 08:33:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36646 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118AbZAKNdk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 08:33:40 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Wang Chen" <wangchen@cn.fujitsu.com>
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera>
In-Reply-To: <XU-8icArWLM.A.UpG.8GfaJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <oWTznAnH9BI.A.GUH.IHfaJB@chimera>
Subject: [Bug #12419] possible circular locking dependency on i915 dma
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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12419
Subject		: possible circular locking dependency on i915 dma
Submitter	: Wang Chen <wangchen@cn.fujitsu.com>
Date		: 2009-01-08 14:11 (4 days old)
References	: http://marc.info/?l=linux-kernel&m=123142399720125&w=4


