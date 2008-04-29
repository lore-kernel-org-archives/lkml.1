Return-Path: <linux-kernel-owner+w=401wt.eu-S1754288AbYD2JxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbYD2JxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 05:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761253AbYD2JxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 05:53:00 -0400
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:56965 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761241AbYD2Jw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 05:52:59 -0400
Date: Tue, 29 Apr 2008 11:53:01 +0200
From: Gabor Gombas <gombasg@sztaki.hu>
To: Bernhard Walle <bwalle@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Solid freezes with 2.6.25
Message-ID: <20080429095301.GE16556@boogie.lpds.sztaki.hu>
References: <20080428142935.GQ14074@boogie.lpds.sztaki.hu> <20080428092513.495378af.akpm@linux-foundation.org> <20080429115029.69a8059b@strauss.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429115029.69a8059b@strauss.suse.de>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 11:50:29AM +0200, Bernhard Walle wrote:

> So the problem goes away if CONFIG_HPET_EMULATE_RTC is not set? I'm
> trying to come up with a debug patch ...

Not sure, did not try that so far. During the day I have to do some real
work but I try to build a kernel with that option not set and boot it
when I leave at the evening.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
