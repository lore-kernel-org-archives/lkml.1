Return-Path: <linux-kernel-owner+w=401wt.eu-S1755776AbYIUUqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbYIUUqb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 16:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbYIUUgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 16:36:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57203 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933AbYIUUgm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 16:36:42 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Steven Noonan" <steven@uplinklabs.net>
References: <PJz8fNrJNHG.A.65F.wzq1IB@albercik>
In-Reply-To: <PJz8fNrJNHG.A.65F.wzq1IB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <7lIhZC4hCxE.A.uuG.a0q1IB@albercik>
Subject: [Bug #11551] Semi-repeatable hard lockup on 2.6.27-rc6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 21 Sep 2008 20:54:20 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11551
Subject		: Semi-repeatable hard lockup on 2.6.27-rc6
Submitter	: Steven Noonan <steven@uplinklabs.net>
Date		: 2008-09-10 18:07 (12 days old)
References	: http://marc.info/?l=linux-kernel&m=122107007407994&w=4


