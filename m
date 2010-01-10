Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541Ab0AJWoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab0AJWoc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 17:44:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335Ab0AJWo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 17:44:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57947 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311Ab0AJWle convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 17:41:34 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
In-Reply-To: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <omZ8aBZReyD.A.czG.8MlSLB@chimera>
Subject: [Bug #15026] i915: Resume regression on MSI Wind U100 w/o KMS
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Jan 2010 23:32:57 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15026
Subject		: i915: Resume regression on MSI Wind U100 w/o KMS
Submitter	: Rafael J. Wysocki <rjw@sisk.pl>
Date		: 2010-01-08 23:45 (3 days old)
References	: http://marc.info/?l=linux-kernel&m=126299433427673&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>
Patch		: http://patchwork.kernel.org/patch/71887/


