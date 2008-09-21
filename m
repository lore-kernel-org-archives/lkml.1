Return-Path: <linux-kernel-owner+w=401wt.eu-S1753662AbYIUUhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbYIUUhK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 16:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbYIUUew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 16:34:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57092 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbYIUUer convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 16:34:47 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       "Hugh Dickins" <hugh@veritas.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>
References: <PJz8fNrJNHG.A.65F.wzq1IB@albercik>
In-Reply-To: <PJz8fNrJNHG.A.65F.wzq1IB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <7lIhZC4hCxE.A.PXB.33q1IB@albercik>
Subject: [Bug #11237] corrupt PMD after resume
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 21 Sep 2008 20:54:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11237
Subject		: corrupt PMD after resume
Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date		: 2008-08-02 9:51 (51 days old)
References	: http://marc.info/?l=linux-kernel&m=121767073424952&w=4
Handled-By	: Hugh Dickins <hugh@veritas.com>
		  Jeremy Fitzhardinge <jeremy@goop.org>
Patch		: http://marc.info/?l=linux-kernel&m=122001615314700&w=2


