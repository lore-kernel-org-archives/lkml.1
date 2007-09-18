Return-Path: <linux-kernel-owner+w=401wt.eu-S1759905AbXIRPps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759905AbXIRPps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 11:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759679AbXIRPpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 11:45:39 -0400
Received: from mout.perfora.net ([74.208.4.195]:50921 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759668AbXIRPpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 11:45:38 -0400
Message-ID: <46EFF173.4010104@rlworkman.net>
Date: Tue, 18 Sep 2007 10:40:35 -0500
From: Robby Workman <rw@rlworkman.net>
Organization: http://rlworkman.net
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: CPU too old panic on Centrino proc - 2.6.22.6
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/2G+x6VjloWYFJD3R/ElXvyEnGywcPZAyGQMG
 LU+O5D8vfNiNsRpLaXIJEyH5/54lfO5ihUJ52dPL0+gdDKWTl3
 T1WPR40IS+SlOar/o4qQg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please CC any replies; not subscribed to list

I found this thread: http://lkml.org/lkml/2007/5/16/499
but it doesn't seem to apply here (bear in mind that I'm probably
not qualified to determine that though :))

On booting a 2.6.22.6 kernel with SMP support, I get a panic
immediately:
  PANIC: CPU too old for this kernel
This panic does not occur on a non-SMP kernel having almost
identical configuration.

This is on a Thinkpad T41:
  /proc/cpuinfo --> http://rlworkman.net/cpuinfo
  dmesg --> http://rlworkman.net/dmesg
  kernel config --> http://rlworkman.net/config-2.6.22.6

The 2.6.21.5 SMP kernels from Slackware 12.0 all boot properly, and
the config for this 2.6.22.6 SMP kernel is based on the one from 12.0.

I'm basically reaching for clues at this point -- is this a PEBKAC on
my part?  What other information would be useful?

(Please CC me on replies)

Thanks,
-RW




