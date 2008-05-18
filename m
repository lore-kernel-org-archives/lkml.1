Return-Path: <linux-kernel-owner+w=401wt.eu-S1762044AbYERMTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762044AbYERMTu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 08:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759323AbYERMNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 08:13:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58379 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759327AbYERMN2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 08:13:28 -0400
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "David Miller" <davem@davemloft.net>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Jan Engelhardt" <jengelh@medozas.de>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>
In-Reply-To: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <7wuznNhcUqC.A.af.1sBMIB@albercik>
Subject: [Bug #10650] 2.6.26-rcX VC console scrolling regression
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 18 May 2008 13:13:55 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10650
Subject		: 2.6.26-rcX VC console scrolling regression
Submitter	: David Miller <davem@davemloft.net>
Date		: 2008-05-07 21:46 (12 days old)
References	: http://lkml.org/lkml/2008/5/8/9
Handled-By	: Jan Engelhardt <jengelh@medozas.de>


