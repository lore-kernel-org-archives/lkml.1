Return-Path: <linux-kernel-owner+w=401wt.eu-S1755219AbZGZXfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbZGZXfc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 19:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755110AbZGZXfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 19:35:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58806 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755207AbZGZXfZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 19:35:25 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Jan Scholz" <scholz@fias.uni-frankfurt.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera>
In-Reply-To: <DizPU9GBfHF.A.kgF.iWObKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <H5-1lZIIeYK.A.BsH.IYObKB@chimera>
Subject: [Bug #13407] adb trackpad disappears after suspend to ram
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Jul 2009 22:45:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13407
Subject		: adb trackpad disappears after suspend to ram
Submitter	: Jan Scholz <scholz@fias.uni-frankfurt.de>
Date		: 2009-05-28 7:59 (60 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=2ed8d2b3a81bdbb0418301628ccdb008ac9f40b7
References	: http://marc.info/?l=linux-kernel&m=124349762314976&w=4
Handled-By	: Rafael J. Wysocki <rjw@sisk.pl>


