Return-Path: <linux-kernel-owner+w=401wt.eu-S1755649AbYKBSwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649AbYKBSwl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 13:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbYKBSpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 13:45:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36207 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676AbYKBSpQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 13:45:16 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Justin Piszcz" <jpiszcz@lucidpixels.com>,
       "Mike Isely" <isely@isely.net>
References: <Sl8SUNhCbfL.A.O5H.yueDJB@chimera>
In-Reply-To: <Sl8SUNhCbfL.A.O5H.yueDJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <4xS1r6m15_B.A.my.GveDJB@chimera>
Subject: [Bug #11829] Kernel 2.6.26.5 -&gt; 2.6.27.2 [USB REGRESSION] (USB -&gt; D_STATE)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  2 Nov 2008 17:49:37 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.26 and 2.6.27.

The following bug entry is on the current list of known regressions
introduced between 2.6.26 and 2.6.27.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11829
Subject		: Kernel 2.6.26.5 -&gt; 2.6.27.2 [USB REGRESSION] (USB -&gt; D_STATE)
Submitter	: Justin Piszcz <jpiszcz@lucidpixels.com>
Date		: 2008-10-19 11:26 (15 days old)
References	: http://marc.info/?l=linux-kernel&m=122441560120027&w=4
Handled-By	: Alan Stern <stern@rowland.harvard.edu>
		  Mike Isely <isely@isely.net>
Patch		: http://linuxtv.org/hg/~mcisely/pvrusb2/rev/0bb411d8d2e4


