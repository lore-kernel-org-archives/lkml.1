Return-Path: <linux-kernel-owner+w=401wt.eu-S1760007AbYILUxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007AbYILUxe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 16:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758479AbYILUpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 16:45:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42846 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758462AbYILUp1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 16:45:27 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "George Gibbs" <Vash63@gmail.com>, "Zhang Rui" <rui.zhang@intel.com>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
In-Reply-To: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <SpS7rta8n4.A.KMH.lcsyIB@albercik>
Subject: [Bug #11471] GPE storm detected, kernel freezes
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 12 Sep 2008 21:06:27 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.26.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11471
Subject		: GPE storm detected, kernel freezes
Submitter	: George Gibbs <Vash63@gmail.com>
Date		: 2008-08-31 22:00 (13 days old)
Handled-By	: Zhang Rui <rui.zhang@intel.com>


