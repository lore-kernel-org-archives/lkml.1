Return-Path: <linux-kernel-owner+w=401wt.eu-S932556AbZHYXgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556AbZHYXgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 19:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932571AbZHYXgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 19:36:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58683 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932499AbZHYXgM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 19:36:12 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Arnd Hannemann" <hannemann@nets.rwth-aachen.de>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>
In-Reply-To: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <_yaHeGjHEzG.A.qRG.usGlKB@chimera>
Subject: [Bug #14062] Failure to boot as xen guest
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 25 Aug 2009 22:34:58 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14062
Subject		: Failure to boot as xen guest
Submitter	: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Date		: 2009-08-25 15:48 (1 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=83b519e8b9572c319c8e0c615ee5dd7272856090
References	: http://marc.info/?l=linux-kernel&m=125121534229538&w=4
Handled-By	: Jeremy Fitzhardinge <jeremy@goop.org>
Patch		: http://patchwork.kernel.org/patch/43799/


