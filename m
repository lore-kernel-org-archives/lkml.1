Return-Path: <linux-kernel-owner+w=401wt.eu-S1756751AbYFNVXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbYFNVXH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 17:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755591AbYFNVTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 17:19:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50291 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332AbYFNVTw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 17:19:52 -0400
Cc: "Bryan Wu" <cooloney@kernel.org>,
       "Javier Herrero" <jherrero@hvsistemas.es>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
In-Reply-To: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Jn7irxIunJK.A.K4E.FKDVIB@albercik>
Subject: [Bug 10764] some serial configurations are now broken
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Jun 2008 22:12:02 +0200 (CEST)
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
Date		: 2008-05-20 7:35 (26 days old)
References	: http://marc.info/?l=linux-kernel&m=121126931810706&w=2
Handled-By	: Javier Herrero <jherrero@hvsistemas.es>
		  Russell King <rmk+lkml@arm.linux.org.uk>


