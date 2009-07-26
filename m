Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbZGZXft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbZGZXft (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 19:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755024AbZGZXfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 19:35:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58821 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755258AbZGZXfm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 19:35:42 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dave Young" <hidave.darkstar@gmail.com>,
       "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera>
In-Reply-To: <DizPU9GBfHF.A.kgF.iWObKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <H5-1lZIIeYK.A.0KH.4XObKB@chimera>
Subject: [Bug #13475] suspend/hibernate lockdep warning
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Jul 2009 22:45:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13475
Subject		: suspend/hibernate lockdep warning
Submitter	: Dave Young <hidave.darkstar@gmail.com>
Date		: 2009-06-02 10:00 (55 days old)
References	: http://marc.info/?l=linux-kernel&m=124393723321241&w=4
Handled-By	: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Patch		: http://patchwork.kernel.org/patch/28660/


