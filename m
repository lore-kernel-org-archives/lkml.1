Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbXLCBCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbXLCBCn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 20:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbXLCBCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 20:02:34 -0500
Received: from lazybastard.de ([212.112.238.170]:39057 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbXLCBCe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 20:02:34 -0500
Date: Mon, 3 Dec 2007 01:57:02 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>, Mark Lord <lkml@rtr.ca>,
       Pavel Machek <pavel@ucw.cz>, Mark Lord <liml@rtr.ca>,
       Thomas Gleixner <tglx@linutronix.de>, len.brown@intel.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, rjw@sisk.pl
Subject: Re: [BUG] Strange 1-second pauses during Resume-from-RAM
Message-ID: <20071203005702.GA12215@lazybastard.org>
References: <20071202113143.GA9378@lazybastard.org> <20071202135711.GA20434@elte.hu> <20071202141117.GB9516@lazybastard.org> <20071202154746.GA27069@elte.hu> <20071202195501.GB10657@lazybastard.org> <20071202200722.GA12101@elte.hu> <20071202203016.GC10657@lazybastard.org> <20071202204559.GA28550@elte.hu> <20071202211026.GB11522@lazybastard.org> <20071202211900.GB7439@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20071202211900.GB7439@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 December 2007 22:19:00 +0100, Ingo Molnar wrote:
> * Jörn Engel <joern@logfs.org> wrote:
> 
> > Maybe one more thing: can you send me the config you used for the 
> > setup above?  I'd like to know whether qemu or my config is to blame.
> 
> sure - attached.

After an eternity of compile time, this config does generate some useful
output.  qemu is not to blame.

Jörn

-- 
Joern's library part 9:
http://www.scl.ameslab.gov/Publications/Gus/TwelveWays.html
