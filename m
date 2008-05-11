Return-Path: <linux-kernel-owner+w=401wt.eu-S1761605AbYEKVK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761605AbYEKVK7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 17:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759434AbYEKVBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 17:01:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34157 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759208AbYEKVBm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 17:01:42 -0400
Cc: "Gabriel C" <nix.or.die@googlemail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
In-Reply-To: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <88YBFoyd1CN.A.8-G.0v1JIB@chimera>
Subject: [Bug #10648] CONFIG_PRINTK_TIME broken on git HEAD ?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 May 2008 22:04:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10648
Subject		: CONFIG_PRINTK_TIME broken on git HEAD ?
Submitter	: Gabriel C <nix.or.die@googlemail.com>
Date		: 2008-05-08 00:26 (4 days old)
References	: http://lkml.org/lkml/2008/5/7/352
Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


