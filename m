Return-Path: <linux-kernel-owner+w=401wt.eu-S1762029AbYEKVM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762029AbYEKVM5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 17:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757643AbYEKVBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 17:01:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34188 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759420AbYEKVBs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 17:01:48 -0400
Cc: "Dave Jones" <davej@codemonkey.org.uk>, "Tilman Schmidt" <tilman@imap.cc>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
In-Reply-To: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <88YBFoyd1CN.A.AbG.kv1JIB@chimera>
Subject: [Bug #10671] [2.6.26-rc1] WARNING: at drivers/base/sys.c:183
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 May 2008 22:04:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10671
Subject		: [2.6.26-rc1] WARNING: at drivers/base/sys.c:183
Submitter	: Tilman Schmidt <tilman@imap.cc>
Date		: 2008-05-11 18:18 (1 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121052996610776&amp;w=4
Handled-By	: Dave Jones <davej@codemonkey.org.uk>


