Return-Path: <linux-kernel-owner+w=401wt.eu-S1758343AbYEaTBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343AbYEaTBm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 15:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755664AbYEaSvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 14:51:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51407 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750AbYEaSvi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 14:51:38 -0400
Cc: "Adrian Bunk" <adrian.bunk@movial.fi>
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik>
In-Reply-To: <90LLR3uLHfN.A.NZC.LqZQIB@albercik>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <UJSav77TyUB.A.2dC.PqZQIB@albercik>
Subject: [Bug #10841] asm-m32r/uaccess.h must #include &lt;asm/setup.h&gt;
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 31 May 2008 19:48:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10841
Subject		: asm-m32r/uaccess.h must #include &lt;asm/setup.h&gt;
Submitter	: Adrian Bunk <adrian.bunk@movial.fi>
Date		: 2008-05-31 07:29 (1 days old)
References	: http://lkml.org/lkml/2008/5/31/87
Handled-By	: Adrian Bunk <adrian.bunk@movial.fi>
Patch		: http://lkml.org/lkml/2008/5/31/87


