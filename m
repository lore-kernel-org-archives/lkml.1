Return-Path: <linux-kernel-owner+w=401wt.eu-S965196AbXCAPRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965196AbXCAPRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 10:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965219AbXCAPRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 10:17:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48038 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965196AbXCAPRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 10:17:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@osdl.org>
Subject: [PATCH -mm 0/7] Freezer changes (take 2)
Date: Thu, 1 Mar 2007 16:05:45 +0100
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Aneesh Kumar <aneesh.kumar@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
References: <200702260800.49603.rjw@sisk.pl>
In-Reply-To: <200702260800.49603.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200703011605.46692.rjw@sisk.pl>
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

