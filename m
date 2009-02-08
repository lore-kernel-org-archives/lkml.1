Return-Path: <linux-kernel-owner+w=401wt.eu-S1757028AbZBHWBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028AbZBHWBQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 17:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbZBHVt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 16:49:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39724 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466AbZBHVt6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 16:49:58 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexey Dobriyan" <adobriyan@gmail.com>, "wixor" <wixorpeek@gmail.com>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>
In-Reply-To: <AIghyjFgMFP.A.uZD._10jJB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <sWhNs83kKPE.A.7EE.O20jJB@chimera>
Subject: [Bug #12664] viafb triggers BUG at mm/vmalloc.c:294
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  8 Feb 2009 20:21:49 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.28.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12664
Subject		: viafb triggers BUG at mm/vmalloc.c:294
Submitter	: wixor <wixorpeek@gmail.com>
Date		: 2009-02-07 19:44 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=123403591109515&w=4
Handled-By	: Alexey Dobriyan <adobriyan@gmail.com>


