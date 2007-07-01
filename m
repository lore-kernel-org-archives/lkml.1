Return-Path: <linux-kernel-owner+w=401wt.eu-S1756915AbXGARaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbXGARaR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 13:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbXGARaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 13:30:07 -0400
Received: from emerald.lightlink.com ([205.232.34.14]:12706 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbXGARaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 13:30:05 -0400
Date: Sun, 1 Jul 2007 13:26:39 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>, khali@linux-fr.org,
       lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [lm-sensors] [PATCH 3/5] use mutex instead of semaphore in SMSC LPC47M192 driver
Message-ID: <20070701172639.GN3516@jupiter.solarsys.private>
References: <20070701162529.GC3940@traven> <20070701163224.GF3940@traven>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070701163224.GF3940@traven>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthias:

* Matthias Kaehlcke <matthias.kaehlcke@gmail.com> [2007-07-01 18:32:24 +0200]:
> The SMSC LPC47M192 driver uses a semaphore as mutex. Use the mutex API
> instead of the (binary) semaphore.
> 
> Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

Already in my testing tree[1] and therefore in latest -mm as well.

[1] http://lm-sensors.org/kernel?p=kernel/mhoffman/hwmon-2.6.git;a=shortlog;h=testing

Regards,

-- 
Mark M. Hoffman
mhoffman@lightlink.com

