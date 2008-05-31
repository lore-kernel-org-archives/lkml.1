Return-Path: <linux-kernel-owner+w=401wt.eu-S1759235AbYEaTIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235AbYEaTIR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 15:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755561AbYEaSwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 14:52:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51414 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755554AbYEaSvd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 14:51:33 -0400
Cc: "Bryan Wu" <cooloney@kernel.org>,
       "Javier Herrero" <jherrero@hvsistemas.es>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik>
In-Reply-To: <90LLR3uLHfN.A.NZC.LqZQIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <UJSav77TyUB.A.fJE.XrZQIB@albercik>
Subject: [Bug #10764] some serial configurations are now broken
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 31 May 2008 19:48:06 +0200 (CEST)
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
Date		: 2008-05-20 7:35 (12 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121126931810706&amp;w=2
Handled-By	: Javier Herrero <jherrero@hvsistemas.es>
		  Russell King <rmk+lkml@arm.linux.org.uk>


