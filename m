Return-Path: <linux-kernel-owner+w=401wt.eu-S1755783AbYIUUqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbYIUUqQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 16:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbYIUUgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 16:36:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57200 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943AbYIUUgl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 16:36:41 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>, "Frans Pop" <elendil@planet.nl>,
       "Rene Herman" <rene.herman@gmail.com>,
       "Rene Herman" <rene.herman@keyaccess.nl>
References: <PJz8fNrJNHG.A.65F.wzq1IB@albercik>
In-Reply-To: <PJz8fNrJNHG.A.65F.wzq1IB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <7lIhZC4hCxE.A.t2G.d0q1IB@albercik>
Subject: [Bug #11550] pnp: Huge number of "io resource overlap" messages
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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11550
Subject		: pnp: Huge number of "io resource overlap" messages
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2008-09-09 10:50 (13 days old)
References	: http://marc.info/?l=linux-kernel&m=122095745403793&w=4
Handled-By	: Rene Herman <rene.herman@keyaccess.nl>
		  Bjorn Helgaas <bjorn.helgaas@hp.com>
Patch		: http://marc.info/?l=linux-kernel&m=122098498125536&w=4


