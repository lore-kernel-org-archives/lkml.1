Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbZGZXm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbZGZXm0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 19:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755185AbZGZXfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 19:35:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58801 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755108AbZGZXfQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 19:35:16 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Frans Pop" <elendil@planet.nl>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera>
In-Reply-To: <DizPU9GBfHF.A.kgF.iWObKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <H5-1lZIIeYK.A.f0H.XYObKB@chimera>
Subject: [Bug #13389] Warning 'Invalid throttling state, reset' gets displayed when it should not be
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 26 Jul 2009 22:45:27 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13389
Subject		: Warning 'Invalid throttling state, reset' gets displayed when it should not be
Submitter	: Frans Pop <elendil@planet.nl>
Date		: 2009-05-26 15:24 (62 days old)
Handled-By	: Frans Pop <elendil@planet.nl>
Patch		: http://bugzilla.kernel.org/attachment.cgi?id=21671
		  http://bugzilla.kernel.org/attachment.cgi?id=21672


