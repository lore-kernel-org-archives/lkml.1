Return-Path: <linux-kernel-owner+w=401wt.eu-S932927AbZDBQwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927AbZDBQwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932674AbZDBQut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:50:49 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:49847 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932726AbZDBQus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:50:48 -0400
From: Jon Masters <jcm@jonmasters.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jon Masters <jcm@redhat.com>, Clark Williams <williams@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Subject: [PATCH 0/2] smi_detector: a simple module for detecting System Management Interrupts
Date: Thu,  2 Apr 2009 12:50:03 -0400
Message-Id: <1238691005-25286-1-git-send-email-jcm@jonmasters.org>
X-Mailer: git-send-email 1.6.0.6
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jcm@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

Please take a look at this simple SMI detector that we have written for use
by those who would like to track down excessive duration or otherwise
undesirable System Management Interrupt overhead on their systems.

This is also available as a git branch. To track that:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/jcm/linux-2.6-jcm.git smi_detector

Thanks,

Jon.


