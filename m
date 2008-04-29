Return-Path: <linux-kernel-owner+w=401wt.eu-S1759944AbYD2Jn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759944AbYD2Jn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 05:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756629AbYD2Jnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 05:43:40 -0400
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:33175 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077AbYD2Jnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 05:43:40 -0400
Date: Tue, 29 Apr 2008 11:43:41 +0200
From: Gabor Gombas <gombasg@sztaki.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Bernhard Walle <bwalle@suse.de>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Solid freezes with 2.6.25
Message-ID: <20080429094341.GC16556@boogie.lpds.sztaki.hu>
References: <20080428142935.GQ14074@boogie.lpds.sztaki.hu> <20080429072423.GB7902@boogie.lpds.sztaki.hu> <20080429003747.6237a0ed.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429003747.6237a0ed.akpm@linux-foundation.org>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 12:37:47AM -0700, Andrew Morton wrote:

> I suspect you have two separate regressions here.

Maybe. But all I see on both boxes is that they freeze hard, Alt+SysRq
does not work, and nothing is logged to syslog. I don't have another
machine near the AMD box so I can't use netconsole there (and the NMI
watchdog does not work there anyway). And both boxes run fine with
2.6.24.x.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
