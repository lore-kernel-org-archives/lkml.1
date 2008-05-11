Return-Path: <linux-kernel-owner+w=401wt.eu-S1761457AbYEKVJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761457AbYEKVJx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 17:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759398AbYEKVBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 17:01:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34144 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759289AbYEKVBk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 17:01:40 -0400
Cc: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
In-Reply-To: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <88YBFoyd1CN.A.TMH._v1JIB@chimera>
Subject: [Bug #10642] general protection fault: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 May 2008 22:04:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10642
Subject		: general protection fault: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Date		: 2008-05-07 16:03 (5 days old)
References	: http://lkml.org/lkml/2008/5/7/48


