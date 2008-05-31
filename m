Return-Path: <linux-kernel-owner+w=401wt.eu-S1755201AbYEaTCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbYEaTCa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 15:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755831AbYEaSvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 14:51:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51435 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755649AbYEaSvg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 14:51:36 -0400
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Rufus &amp; Azrael" <rufus-azrael@numericable.fr>
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik>
In-Reply-To: <90LLR3uLHfN.A.NZC.LqZQIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <UJSav77TyUB.A.00C.gqZQIB@albercik>
Subject: [Bug #10828] [2.6.25-git18 =&gt; 2.6.26-rc1-git1] Xorg crash with xf86MapVidMem error
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 31 May 2008 19:48:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10828
Subject		: [2.6.25-git18 =&gt; 2.6.26-rc1-git1] Xorg crash with xf86MapVidMem error
Submitter	: Rufus &amp; Azrael <rufus-azrael@numericable.fr>
Date		: 2008-05-04 10:24 (28 days old)
References	: http://lkml.org/lkml/2008/5/4/37
Handled-By	: Ingo Molnar <mingo@elte.hu>
		  H. Peter Anvin <hpa@zytor.com>
		  Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
Patch		: http://lkml.org/lkml/2008/5/29/371


