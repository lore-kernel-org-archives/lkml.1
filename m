Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbYFNV0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbYFNV0f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 17:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755906AbYFNVUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 17:20:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50307 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755894AbYFNVUA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 17:20:00 -0400
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Rufus &amp; Azrael" <rufus-azrael@numericable.fr>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
In-Reply-To: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <Jn7irxIunJK.A.4IE.WJDVIB@albercik>
Subject: [Bug 10828] [2.6.25-git18 =&gt; 2.6.26-rc1-git1] Xorg crash with xf86MapVidMem error
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 14 Jun 2008 22:12:03 +0200 (CEST)
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
Date		: 2008-05-04 10:24 (42 days old)
References	: http://lkml.org/lkml/2008/5/4/37
Handled-By	: Ingo Molnar <mingo@elte.hu>
		  H. Peter Anvin <hpa@zytor.com>
		  Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
Patch		: http://lkml.org/lkml/2008/5/29/371


