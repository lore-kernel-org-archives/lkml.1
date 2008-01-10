Return-Path: <linux-kernel-owner+w=401wt.eu-S1759249AbYAJIwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759249AbYAJIwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 03:52:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbYAJIvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 03:51:55 -0500
Received: from mx1.ukfsn.org ([77.75.108.10]:45503 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753800AbYAJIvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 03:51:54 -0500
Date: Thu, 10 Jan 2008 08:51:50 +0000
From: Nick Warne <nick@ukfsn.org>
To: linux-kernel@vger.kernel.org
Subject: Driver 'sd' needs updating
Message-ID: <20080110085150.53addacf@linuxamd.linicks.net>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.10.14; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi everybody - Happy New Year to you all!

OK, updated to git rc7 yesterday - I now see this in syslog:

   "Driver 'sd' needs updating - please use bus_type methods"

The warning never appeared in RC6, and all google reveals are other
peoples logs that are posted about other issues.

Do I need to fix up something here?

Thanks,

Nick
-- 
Free Software Foundation Associate Member 5508
