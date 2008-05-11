Return-Path: <linux-kernel-owner+w=401wt.eu-S1759809AbYEKVDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759809AbYEKVDP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 17:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759213AbYEKVBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 17:01:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34089 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758957AbYEKVBY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 17:01:24 -0400
Cc: "Alexey Fisher" <bug-track@fisher-privat.net>,
       "Jeff Garzik" <jgarzik@redhat.com>, "Tejun Heo" <htejun@gmail.com>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
In-Reply-To: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <88YBFoyd1CN.A.j0.yw1JIB@chimera>
Subject: [Bug #10619] [regression] ata2: device not ready (errno=-16), forcing hardreset
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 11 May 2008 22:04:13 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.25.  Please verify if it still should be listed.


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10619
Subject		: [regression] ata2: device not ready (errno=-16), forcing hardreset
Submitter	: Alexey Fisher <bug-track@fisher-privat.net>
Date		: 2008-05-08 06:49 (4 days old)


