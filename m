Return-Path: <linux-kernel-owner+w=401wt.eu-S933786AbXBZHWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933786AbXBZHWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 02:22:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933785AbXBZHVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 02:21:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57891 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964776AbXBZHVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 02:21:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@osdl.org>
Subject: [PATCH -mm 0/6] Freezer changes
Date: Mon, 26 Feb 2007 08:00:48 +0100
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Aneesh Kumar <aneesh.kumar@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200702260800.49603.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following series of patches contains modifications of the task freezer that
harden it and prepare it to be used in the CPU hotplug.

Greetings,
Rafael

