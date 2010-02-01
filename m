Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab0BAA6d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 19:58:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50616 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755115Ab0BAA6a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 19:58:30 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Stefan Zegenhagen" <sz@emlix.com>
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera>
In-Reply-To: <UgwvXSBS_tM.A.alD.1EiZLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <de962C6zBxL.A.H3F.eGiZLB@chimera>
Subject: [Bug #14783] Unhandled IRQ on Thinkpad R61i: "irq 16: nobody cared"
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon,  1 Feb 2010 01:43:14 +0100 (CET)
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
Date		: 2009-12-10 19:14 (53 days old)


