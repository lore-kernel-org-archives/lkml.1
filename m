Return-Path: <linux-kernel-owner+w=401wt.eu-S1753707AbZGFXtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbZGFXtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 19:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754952AbZGFXtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 19:49:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57791 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525AbZGFXtR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 19:49:17 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan Cox" <alan@linux.intel.com>,
       "Sergey Senozhatsky" <sergey.senozhatsky@mail.by>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
In-Reply-To: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <dWkuWjWDsSB.A.xuF.70oUKB@chimera>
Subject: [Bug #13522] BUG: scheduling while atomic
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  7 Jul 2009 01:42:16 +0200 (CEST)
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
Date		: 2009-06-12 19:29 (25 days old)
References	: http://lkml.org/lkml/2009/6/29/237


