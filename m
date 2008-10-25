Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbYJYW7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbYJYW7e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 18:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbYJYW7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 18:59:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52073 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbYJYW7I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 18:59:08 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jean-Luc Coulon" <jean.luc.coulon@gmail.com>
References: <3ZqdCuOdOqB.A.EPE.fJ6AJB@chimera>
In-Reply-To: <3ZqdCuOdOqB.A.EPE.fJ6AJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <gLTYxg3cC1.A.p0G.WN6AJB@chimera>
Subject: [Bug #11264] Invalid op opcode in kernel/workqueue
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 25 Oct 2008 23:07:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.26 and 2.6.27.

The following bug entry is on the current list of known regressions
introduced between 2.6.26 and 2.6.27.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11264
Subject		: Invalid op opcode in kernel/workqueue
Submitter	: Jean-Luc Coulon <jean.luc.coulon@gmail.com>
Date		: 2008-08-07 04:18 (80 days old)


