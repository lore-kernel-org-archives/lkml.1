Return-Path: <linux-kernel-owner+w=401wt.eu-S1763412AbYFGVyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763412AbYFGVyw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 17:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759479AbYFGVsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 17:48:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38975 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758338AbYFGVsa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 17:48:30 -0400
Cc: "Bryan Wu" <cooloney@kernel.org>,
       "Javier Herrero" <jherrero@hvsistemas.es>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik>
In-Reply-To: <GIilET9wkhI.A.JzB.81vSIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <dCRO4tbfLzK.A.v4D.h3vSIB@albercik>
Subject: [Bug #10764] some serial configurations are now broken
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat,  7 Jun 2008 22:42:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10764
Subject		: some serial configurations are now broken
Submitter	: Russell King <rmk+lkml@arm.linux.org.uk>
Date		: 2008-05-20 7:35 (19 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121126931810706&amp;w=2
Handled-By	: Javier Herrero <jherrero@hvsistemas.es>
		  Russell King <rmk+lkml@arm.linux.org.uk>


