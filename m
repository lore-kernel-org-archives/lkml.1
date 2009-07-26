Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbZGZXl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbZGZXl1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 19:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754982AbZGZXfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 19:35:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58823 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260AbZGZXfn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 19:35:43 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "" <sveina@gmail.com>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera>
In-Reply-To: <DizPU9GBfHF.A.kgF.iWObKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <H5-1lZIIeYK.A.1DH.yXObKB@chimera>
Subject: [Bug #13502] GPE storm causes polling mode, which causes /proc/acpi/battery read to take 4 seconds - MacBookPro4,1
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


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13502
Subject		: GPE storm causes polling mode, which causes /proc/acpi/battery read to take 4 seconds - MacBookPro4,1
Submitter	:  <sveina@gmail.com>
Date		: 2009-06-10 20:04 (47 days old)


