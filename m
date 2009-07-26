Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbZGZXRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbZGZXRn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 19:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbZGZXRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 19:17:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58422 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065AbZGZXRl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 19:17:41 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David Howells" <dhowells@redhat.com>,
       "MinChan Kim" <minchan.kim@gmail.com>,
       "Wu Fengguang" <fengguang.wu@intel.com>
References: <Jya1GruKQpD.A.16.2GObKB@chimera>
In-Reply-To: <Jya1GruKQpD.A.16.2GObKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <3zAHs5O6maO.A.44E.QIObKB@chimera>
Subject: [Bug #13665] commit 69c854817566 causes OOMs
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Jul 2009 22:28:20 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13665
Subject		: commit 69c854817566 causes OOMs
Submitter	: David Howells <dhowells@redhat.com>
Date		: 2009-06-27 08:12 (30 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=69c854817566db82c362797b4a6521d0b00fe1d8
References	: http://lkml.org/lkml/2009/6/27/28
Handled-By	: Wu Fengguang <fengguang.wu@intel.com>
Patch		: http://patchwork.kernel.org/patch/32740/


