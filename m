Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbZGGAAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbZGGAAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 20:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755518AbZGFX5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 19:57:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57893 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535AbZGFX5h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 19:57:37 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Daniel J Blueman" <daniel.blueman@gmail.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
In-Reply-To: <35kKlbXMqWN.A.RXD.D0oUKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <dWkuWjWDsSB.A.vzD.M0oUKB@chimera>
Subject: [Bug #13730] hitting lockdep limits...
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue,  7 Jul 2009 01:49:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.30.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13730
Subject		: hitting lockdep limits...
Submitter	: Daniel J Blueman <daniel.blueman@gmail.com>
Date		: 2009-07-05 18:19 (2 days old)
References	: http://marc.info/?l=linux-kernel&m=124681799023782&w=4


