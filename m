Return-Path: <linux-kernel-owner+w=401wt.eu-S1758945AbXHXLhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945AbXHXLhK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 07:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbXHXLg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 07:36:59 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:45379 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584AbXHXLg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 07:36:59 -0400
Date: Fri, 24 Aug 2007 14:36:56 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: isapnp & module autoload (udev?)
Message-ID: <Pine.SOC.4.64.0708241434440.27738@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tested 2.6.23-rc3 along with Debian unstable on a older pentium2-era 
PC that has a ISA bus sound card that isapnp finds. snd-sb finds it too 
using isapnp. However, there seems to be no module autoloading 
happening.

So, the question is: should isapnp moudle autoloading work with current 
kernel + current udev?

-- 
Meelis Roos (mroos@linux.ee)
