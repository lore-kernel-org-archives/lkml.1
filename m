Return-Path: <linux-kernel-owner+w=401wt.eu-S1759817AbZDQAgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759817AbZDQAgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759470AbZDQAdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:33:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36525 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759439AbZDQAd2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:33:28 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Bruno" <bonbons67@internet.lu>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
In-Reply-To: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <nY3-4PrO6XH.A.iTB.nw85JB@chimera>
Subject: [Bug #13087] boot hang due to commit ff69f2bba67bd45514923aaedbf40fe351787c59
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 16 Apr 2009 23:45:02 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.29.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13087
Subject		: boot hang due to commit ff69f2bba67bd45514923aaedbf40fe351787c59
Submitter	: Bruno <bonbons67@internet.lu>
Date		: 2009-04-14 17:51 (3 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ff69f2bba67bd45514923aaedbf40fe351787c59


