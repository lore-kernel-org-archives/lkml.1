Return-Path: <linux-kernel-owner+w=401wt.eu-S965261AbXA3E6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965261AbXA3E6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 23:58:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965281AbXA3E6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 23:58:05 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:59020 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965261AbXA3E6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 23:58:02 -0500
Message-ID: <45BED029.8080100@sgi.com>
Date: Tue, 30 Jan 2007 05:57:13 +0100
From: Jes Sorensen <jes@sgi.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Greg Ungerer <gerg@snapgear.com>
Cc: Dave Jones <davej@redhat.com>, Theodore Tso <tytso@mit.edu>,
       Sunil Naidu <akula2.shark@gmail.com>, linux-kernel@vger.kernel.org,
       dirk.hohndel@intel.com, alan@redhat.com, ksummit-2007-discuss@thunk.org,
       David Miller <davem@davemloft.net>
Subject: Re: [Ksummit-2007-discuss] Re: [Ksummit-2006-discuss] 2007 Linux
 Kernel Summit
References: <20070123.095756.30177490.davem@davemloft.net>	<C1DDFD3E.8658%dirk.hohndel@intel.com>	<20070125.125121.98861775.davem@davemloft.net>	<8355959a0701251646t4b7db48cj862268aad52e8e24@mail.gmail.com>	<20070126032849.GB5589@thunk.org>	<8355959a0701260704x6aea8141s3d0581fa33c74cf2@mail.gmail.com>	<20070126195024.GE14759@thunk.org> <45BE8BF9.6020204@sgi.com> <20070130030430.GA21772@redhat.com> <45BEBBF0.3050102@snapgear.com>
In-Reply-To: <45BEBBF0.3050102@snapgear.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Ungerer wrote:
> Dave Jones wrote:
>> Again, I don't recall us spending any time at all discussing m68k, or
>> sparc, whilst the others you mention were well represented.
> 
> Well, others where represented, I was there looking after non-mmu m68k
> for example (and other general non-mmu stuff). There just wasn't much
> contentious stuff in that space that needed wider discussion.

Which is good, provided that non-mmu work is actively driving some of
the decisions in mainline. Given that I don't follow the non-mmu work
at all, I don't have a feel for whether that is the case, but I could
imagine that it would have some impact that needs to be taken into
account at times. My worry is for spending time and slots on things /
people dealing with classic architectures which are no longer being
manufactured and are only being maintained in catch-up mode.

Cheers,
Jes
