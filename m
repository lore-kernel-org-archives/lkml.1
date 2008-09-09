Return-Path: <linux-kernel-owner+w=401wt.eu-S1756087AbYIISgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbYIISgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 14:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbYIISgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 14:36:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46720 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbYIISga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 14:36:30 -0400
Date: Tue, 9 Sep 2008 20:40:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mark Lord <lkml@rtr.ca>
Cc: Andi Kleen <andi@firstfloor.org>, Krzysztof Halasa <khc@pm.waw.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>,
       x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] x86 fixes
Message-ID: <20080909184008.GA7714@one.firstfloor.org>
References: <200809081752.m88Hq6tn005080@askone.hos.anvin.org> <alpine.LFD.1.10.0809081056350.3117@nehalem.linux-foundation.org> <48C56D60.7010405@zytor.com> <20080908114619.741b6786@infradead.org> <48C57439.3040903@zytor.com> <20080908190249.GA21998@elte.hu> <alpine.LFD.1.10.0809081213330.3117@nehalem.linux-foundation.org> <m3vdx6xm68.fsf@maximus.localdomain> <87d4jdty5b.fsf@basil.nowhere.org> <48C6AFA4.1050206@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C6AFA4.1050206@rtr.ca>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Our firewall here uses a Via C3-600 CPU, and CMOV has never worked on it.
> But based upon your posting, I have today upgraded the BIOS to the
> latest (2004) version.

That's probably not new enough. 

> 
> Now.. how can I check whether CMOV works or not?  It's not listed in 
> /proc/cpuinfo.

If it's not in cpuinfo it won't work.

-Andi

-- 
ak@linux.intel.com
