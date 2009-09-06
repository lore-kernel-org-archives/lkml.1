Return-Path: <linux-kernel-owner+w=401wt.eu-S1758603AbZIFUbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603AbZIFUbt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 16:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758548AbZIFU3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 16:29:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48796 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758532AbZIFU3C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 16:29:02 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Oliver Neukum" <oliver@neukum.org>, "Paul Martin" <pm@debian.org>
References: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera>
In-Reply-To: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Vm51Upp4EV.A.yPC.KfBpKB@chimera>
Subject: [Bug #14103] cdc_acm gives I/O error
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  6 Sep 2009 19:24:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14103
Subject		: cdc_acm gives I/O error
Submitter	: Paul Martin <pm@debian.org>
Date		: 2009-09-01 13:30 (6 days old)
Handled-By	: Oliver Neukum <oliver@neukum.org>


