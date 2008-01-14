Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbYANP1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbYANP1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 10:27:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751112AbYANP05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 10:26:57 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:50636 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbYANP04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 10:26:56 -0500
Date: Mon, 14 Jan 2008 17:25:57 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, rjw@sisk.pl, pavel@suse.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without
	HOTPLUG_CPU
Message-ID: <20080114152557.GA9240@does.not.exist>
References: <20080103442.621670000@suse.de> <20080110111514.GS25945@bingen.suse.de> <20080110112607.GE28740@does.not.exist> <200801101242.53504.ak@suse.de> <20080110124702.GF28740@does.not.exist> <p73fxx5omck.fsf@bingen.suse.de> <20080110150911.GG28740@does.not.exist> <20080114135240.GA15357@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080114135240.GA15357@elte.hu>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 02:52:40PM +0100, Ingo Molnar wrote:
>...
> but longer-term, shouldnt these annotations be automated? We'll see a 
> constant stream of them, all around the clock as people regularly get it 
> wrong (because it's not intuitive).

Definitely.

Even more when you looking at what Maciej Rozycki suggested regarding 
discardable strings. [1]

But _how_ can we get this automated at all?

> 	Ingo

cu
Adrian

[1] http://lkml.org/lkml/2007/10/12/297

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

