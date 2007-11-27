Return-Path: <linux-kernel-owner+w=401wt.eu-S1759964AbXK0VjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759964AbXK0VjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 16:39:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757724AbXK0Vit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 16:38:49 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33849 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757495AbXK0Vis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 16:38:48 -0500
Date: Tue, 27 Nov 2007 22:38:37 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Rick Jones <rick.jones2@hp.com>
Cc: Dave Jones <davej@redhat.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Roland Dreier <rdreier@cisco.com>, Andi Kleen <ak@suse.de>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro.
Message-ID: <20071127213837.GG3406@stusta.de>
References: <20071122343.446909000@suse.de> <adatznarrzc.fsf@cisco.com> <200711261228.15155.rusty@rustcorp.com.au> <20071126102533.1c774870@freepuppy.rosehill.pdx.hemminger.net> <20071127190037.GB30057@redhat.com> <20071127210942.GF3406@stusta.de> <474C88EB.9040300@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <474C88EB.9040300@hp.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 01:15:23PM -0800, Rick Jones wrote:
>> The real problem is that these drivers are not in the upstream kernel.
>>
>> Are there common reasons why these drivers are not upstream?
>
> One might be that upstream has not accepted them.  Anything doing or 
> smelling of TOE comes to mind right away.

Which modules doing or smelling of TOE do work with unmodified vendor 
kernels?

AFAIR TOE was both not a module and required some hooks in the network 
stack, so it's completely outside the scope of this thread.

> rick jones

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

