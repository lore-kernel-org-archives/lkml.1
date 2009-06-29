Return-Path: <linux-kernel-owner+w=401wt.eu-S1761405AbZF2Ard@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761405AbZF2Ard (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 20:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758651AbZF2AoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 20:44:11 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56472 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760926AbZF2AoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 20:44:09 -0400
Message-ID: <4A480E54.3060405@jp.fujitsu.com>
Date: Mon, 29 Jun 2009 09:44:04 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #13653] system hangs after resume from suspend to disk,
 mce related
References: <ij4ZQY4URcP.A.F3B.vIASKB@chimera> <6JJ2m5kyucK.A.EED.DJASKB@chimera>
In-Reply-To: <6JJ2m5kyucK.A.EED.DJASKB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13653
> Subject		: system hangs after resume from suspend to disk, mce related
> Submitter	: Maciej Rutecki <maciej.rutecki@gmail.com>
> Date		: 2009-06-21 19:02 (8 days old)
> References	: http://lkml.org/lkml/2009/6/21/86
> Handled-By	: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> Patch		: http://patchwork.kernel.org/patch/32062/

The patch above, in /32062/, is for another bug related to timer
migration (waring message reported with check_interval=1).

Real patch for this bug is:
 http://patchwork.kernel.org/patch/31907/


Thanks,
H.Seto

