Return-Path: <linux-kernel-owner+w=401wt.eu-S1761962AbYEKVMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761962AbYEKVMj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 17:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756710AbYEKVBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 17:01:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34186 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759421AbYEKVBr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 17:01:47 -0400
Cc: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Karol Lewandowski" <lmctlx@gmail.com>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
In-Reply-To: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <88YBFoyd1CN.A.qfG.mv1JIB@chimera>
Subject: [Bug #10670] BUG: linux-2.6.26-rc1 oops at thinkpad_acpi:led_set_status
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 May 2008 22:04:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10670
Subject		: BUG: linux-2.6.26-rc1 oops at thinkpad_acpi:led_set_status
Submitter	: Karol Lewandowski <lmctlx@gmail.com>
Date		: 2008-05-08 23:12 (4 days old)
References	: http://marc.info/?l=linux-kernel&amp;m=121028841527994&amp;w=4
Handled-By	: Henrique de Moraes Holschuh <hmh@hmh.eng.br>


