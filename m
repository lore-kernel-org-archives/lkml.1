Return-Path: <linux-kernel-owner+w=401wt.eu-S1755061AbZGZXed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061AbZGZXed (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 19:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755033AbZGZXe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 19:34:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58755 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978AbZGZXeZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 19:34:25 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dave Airlie" <airlied@redhat.com>,
       "Jerome Glisse" <glisse@freedesktop.org>,
       "Karsten Mehrhoff" <kawime@gmx.de>,
       "=?utf-8?q?Michel=20D=C3=A4nzer?=" <michel@daenzer.net>,
       "Shaohua Li" <shaohua.li@intel.com>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera>
In-Reply-To: <DizPU9GBfHF.A.kgF.iWObKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <H5-1lZIIeYK.A.fu.DZObKB@chimera>
Subject: [Bug #13318] AGP doesn't work anymore on nforce2
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Jul 2009 22:45:26 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13318
Subject		: AGP doesn't work anymore on nforce2
Submitter	: Karsten Mehrhoff <kawime@gmx.de>
Date		: 2009-04-30 8:51 (88 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=59de2bebabc5027f93df999d59cc65df591c3e6e
References	: http://marc.info/?l=linux-kernel&m=124108156417560&w=4
Handled-By	: Shaohua Li <shaohua.li@intel.com>


