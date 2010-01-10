Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913Ab0AJXEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab0AJXEv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 18:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224Ab0AJXEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 18:04:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58236 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151Ab0AJXEo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 18:04:44 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Stefan Zegenhagen" <sz@emlix.com>
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera>
In-Reply-To: <nzLqtSp97aP.A.RGB.hglSLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <CXIfLt-ygXM.A.zxC.bhlSLB@chimera>
Subject: [Bug #14783] Unhandled IRQ on Thinkpad R61i: "irq 16: nobody cared"
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 10 Jan 2010 23:56:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.31 and 2.6.32.

The following bug entry is on the current list of known regressions
introduced between 2.6.31 and 2.6.32.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14783
Subject		: Unhandled IRQ on Thinkpad R61i: "irq 16: nobody cared"
Submitter	: Stefan Zegenhagen <sz@emlix.com>
Date		: 2009-12-10 19:14 (32 days old)


