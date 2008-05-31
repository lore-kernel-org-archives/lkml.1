Return-Path: <linux-kernel-owner+w=401wt.eu-S1758389AbYEaTDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389AbYEaTDJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 15:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755991AbYEaSvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 14:51:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51428 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755612AbYEaSve convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 14:51:34 -0400
Cc: "Mikael Pettersson" <mikpe@it.uu.se>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik>
In-Reply-To: <90LLR3uLHfN.A.NZC.LqZQIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <UJSav77TyUB.A.WKD.vqZQIB@albercik>
Subject: [Bug #10822] sky2 oops in 2.6.26-rc3
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 31 May 2008 19:48:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10822
Subject		: sky2 oops in 2.6.26-rc3
Submitter	: Mikael Pettersson <mikpe@it.uu.se>
Date		: 2008-05-25 17:27 (7 days old)
References	: http://marc.info/?l=linux-netdev&amp;m=121173650915153&amp;w=4
Handled-By	: Stephen Hemminger <shemminger@linux-foundation.org>


