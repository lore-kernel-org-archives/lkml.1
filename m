Return-Path: <linux-kernel-owner+w=401wt.eu-S1754198AbZIALsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbZIALsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 07:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbZIALsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 07:48:18 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:35950 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937AbZIALsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 07:48:17 -0400
Date: Tue, 1 Sep 2009 14:48:18 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Tejun Heo <tj@kernel.org>
cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: boot panic after oops from sysfs_new_dirent
In-Reply-To: <4A9CD41C.8060604@kernel.org>
Message-ID: <Pine.SOC.4.64.0909011437270.20321@math.ut.ee>
References: <Pine.SOC.4.64.0908311646150.20934@math.ut.ee>
 <20090831.142215.111904849.davem@davemloft.net> <Pine.SOC.4.64.0909011003460.10184@math.ut.ee>
 <4A9CC9E9.2070609@kernel.org> <4A9CCD92.4090909@kernel.org>
 <Pine.SOC.4.64.0909011032350.10835@math.ut.ee> <4A9CD41C.8060604@kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Aha...  Does the following patch fix the problem?

Yes, yesterdays 2.6.31-rc8-git plus this patch seems to work fine, no 
warnings/oopses/panics. It is happily churning on debian unstable 
upgrade now.

-- 
Meelis Roos (mroos@linux.ee)
