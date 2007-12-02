Return-Path: <linux-kernel-owner+w=401wt.eu-S1755801AbXLBVOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801AbXLBVOO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 16:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbXLBVN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 16:13:59 -0500
Received: from lazybastard.de ([212.112.238.170]:58673 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbXLBVN7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 16:13:59 -0500
Date: Sun, 2 Dec 2007 22:08:27 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>, Mark Lord <lkml@rtr.ca>,
       Pavel Machek <pavel@ucw.cz>, Mark Lord <liml@rtr.ca>,
       Thomas Gleixner <tglx@linutronix.de>, len.brown@intel.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, rjw@sisk.pl
Subject: Re: [BUG] Strange 1-second pauses during Resume-from-RAM
Message-ID: <20071202210826.GA11522@lazybastard.org>
References: <20071201234112.GA7209@lazybastard.org> <20071202085607.GA28966@elte.hu> <20071202113143.GA9378@lazybastard.org> <20071202135711.GA20434@elte.hu> <20071202141117.GB9516@lazybastard.org> <20071202154746.GA27069@elte.hu> <20071202195501.GB10657@lazybastard.org> <20071202200722.GA12101@elte.hu> <20071202203016.GC10657@lazybastard.org> <20071202204559.GA28550@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20071202204559.GA28550@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 December 2007 21:45:59 +0100, Ingo Molnar wrote:
> 
> to capture a 1 second trace of what the system is doing. I think your 
> troubles are due to running it within a qemu guest - that is not a 
> typical utilization so you are on unchartered waters.

Looks like it.  Guess I'll switch to something else for the moment.

Jörn

-- 
Linux is more the core point of a concept that surrounds "open source"
which, in turn, is based on a false concept. This concept is that
people actually want to look at source code.
-- Rob Enderle
