Return-Path: <linux-kernel-owner+w=401wt.eu-S1764825AbXKNU4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764825AbXKNU4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 15:56:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763683AbXKNUzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 15:55:52 -0500
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:58338
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758432AbXKNUzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 15:55:50 -0500
Date: Wed, 14 Nov 2007 13:05:26 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Ingo Molnar <mingo@elte.hu>
cc: David Miller <davem@davemloft.net>, rdunlap@xenotime.net,
       akpm@linux-foundation.org, protasnb@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-ide@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-input@atrey.karlin.mff.cuni.cz,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [BUG] New Kernel Bugs
In-Reply-To: <20071114204840.GB20606@elte.hu>
Message-ID: <Pine.LNX.4.64.0711141303210.29641@asgard.lang.hm>
References: <20071113134029.GA30978@elte.hu> <20071113085514.3414aa52.rdunlap@xenotime.net>
 <20071114140847.GA11489@elte.hu> <20071114.115601.00715073.davem@davemloft.net>
 <20071114204840.GB20606@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007, Ingo Molnar wrote:

>> Dumping even more crap on lkml is not the answer.
>
> that "crap" that i'd like to see dumped upon lkml would be netdev
> traffic mainly - most of the other kernel development lists (and i'm
> subscribed to many of them) are low-traffic. netdev is the main reason
> why we cannot do a "one common discussion forum" approach.

hmm, how much work would it be to tweak the mail software on vger to have 
a linux-all@vger.kernel.org that got a copy of any linux-* list hosted by 
vger.

this would solve half the problem (people on linux-kernel not seeing 
discussions on the other lists)

David Lang
