Return-Path: <linux-kernel-owner+w=401wt.eu-S1030195AbXBZKvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030195AbXBZKvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 05:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030199AbXBZKvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 05:51:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59238 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030195AbXBZKvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 05:51:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 0/3] More freezer patches
Date: Mon, 26 Feb 2007 11:39:57 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Pavel Machek <pavel@ucw.cz>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Aneesh Kumar <aneesh.kumar@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702261139.59130.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have separated the patch supposed to fix the freezer's vfork problem from the
previous series, because it seems to be controversial.  Moreover, I have one
more patch on top of it and a related, also a bit controversial one.

Please have a look and advise.

Greetings,
Rafael


-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King

