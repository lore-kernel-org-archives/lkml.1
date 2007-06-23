Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbXFWWXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbXFWWXw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 18:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbXFWWXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 18:23:46 -0400
Received: from acrux.ligo.caltech.edu ([131.215.115.14]:43033 "EHLO
	acrux.ligo.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbXFWWXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 18:23:45 -0400
X-Greylist: delayed 944 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Jun 2007 18:23:45 EDT
Date: Sat, 23 Jun 2007 15:07:55 -0700
From: Stuart Anderson <anderson@ligo.caltech.edu>
To: linux-kernel@vger.kernel.org
Subject: i2c_adapter unrecognized stepping
Message-ID: <20070623220755.GA29173@ligo.caltech.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
X-Spam-Score: undef - Domain Whitelisted (ligo.caltech.edu: )
X-Canit-Stats-ID: 6899218 - f658bddfbb23
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Booting the 2.6.20.14 kernel on a Sun X4600M2 genreates the following messgae
about unrecognized stepping. Is this a known issue and/or problem?

Thanks.

...
kernel: Initializing CPU#15
kernel: Calibrating delay using timer specific routine.. 5186.68 BogoMIPS (lpj=10373366)
kernel: CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
kernel: CPU: L2 Cache: 1024K (64 bytes/line)
kernel: CPU 15/f -> Node 7
kernel: CPU: Physical Processor ID: 7
kernel: CPU: Processor Core ID: 1
kernel: Dual-Core AMD Opteron(tm) Processor 8218 stepping 02
kernel: CPU 15: Syncing TSC to CPU 0.
kernel: CPU 15: synchronized TSC with CPU 0 (last diff -38 cycles, maxerr 2285 cycles)
kernel: Brought up 16 CPUs
...
kernel: i2c_adapter i2c-1: : Unrecognized stepping 0x45. Defaulting to ADM1026.
kernel: i2c_adapter i2c-1: : Unrecognized stepping 0x45. Defaulting to ADM1026.
kernel: i2c_adapter i2c-1: : Found version/stepping 0x46. Assuming generic ADM1026.

-- 
Stuart Anderson  anderson@ligo.caltech.edu
http://www.ligo.caltech.edu/~anderson
