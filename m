Return-Path: <linux-kernel-owner+w=401wt.eu-S1758297AbXHEJaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297AbXHEJaA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 05:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbXHEJ3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 05:29:51 -0400
Received: from mailhub.lawrence.edu ([143.44.0.14]:59527 "EHLO lawrence.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751179AbXHEJ3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 05:29:50 -0400
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Aug 2007 05:29:50 EDT
Message-ID: <46B58A69.20708@gmail.com>
Date: Sun, 05 Aug 2007 04:29:29 -0400
From: Dan Zwell <dzwell@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: tuning CFS: /proc/sys/kernel/sched_granularity_ns question
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi. I see "/proc/sys/kernel/sched_granularity_ns" mentioned on web sites 
and such, but I do have this file and cannot create it. Yes, I am root 
and /proc is mounted. Are there boot parameters that I must enable to 
tune this variable? Do I need to specifically enable this in .config?

I am using 2.6.23-rc2.

Thanks,
Dan
