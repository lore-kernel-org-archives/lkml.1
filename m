Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbZGGAA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbZGGAA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 20:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755506AbZGFX5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 19:57:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57890 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755383AbZGFX5e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 19:57:34 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Eric Paris" <eparis@redhat.com>, "Mikko C." <mikko.cal@gmail.com>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
In-Reply-To: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <dWkuWjWDsSB.A.i5D.N0oUKB@chimera>
Subject: [Bug #13729] kernel BUG at fs/notify/notification.c:93!
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  7 Jul 2009 01:49:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13729
Subject		: kernel BUG at fs/notify/notification.c:93!
Submitter	: Mikko C. <mikko.cal@gmail.com>
Date		: 2009-06-04 10:16 (33 days old)
References	: http://lkml.org/lkml/2009/7/4/12
Handled-By	: Eric Paris <eparis@redhat.com>


