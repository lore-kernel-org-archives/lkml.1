Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbZHSXZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbZHSXZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 19:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753623AbZHSXZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 19:25:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34204 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640AbZHSXZD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 19:25:03 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "=?utf-8?q?Bruno=20Pr=C3=A9mont?=" <bonbons@linux-vserver.org>
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera>
In-Reply-To: <jCYznkTxcLB.A.EPH.eNIjKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <ADSuNT6McuD.A.-K.4NIjKB@chimera>
Subject: [Bug #13950] Oops when USB Serial disconnected while in use
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 19 Aug 2009 22:26:59 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13950
Subject		: Oops when USB Serial disconnected while in use
Submitter	: Bruno Prémont <bonbons@linux-vserver.org>
Date		: 2009-08-08 17:47 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=124975432900466&w=4


