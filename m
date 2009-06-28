Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbZF1X4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbZF1X4A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 19:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754902AbZF1Xzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 19:55:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38365 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873AbZF1Xzb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 19:55:31 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Cox" <alan@linux.intel.com>,
       "Sergey Senozhatsky" <sergey.senozhatsky@mail.by>
References: <ij4ZQY4URcP.A.F3B.vIASKB@chimera>
In-Reply-To: <ij4ZQY4URcP.A.F3B.vIASKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <6JJ2m5kyucK.A.D2D.VJASKB@chimera>
Subject: [Bug #13522] BUG: scheduling while atomic
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 29 Jun 2009 01:51:09 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13522
Subject		: BUG: scheduling while atomic
Submitter	: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Date		: 2009-06-12 19:29 (17 days old)


