Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbZJFRmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbZJFRmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 13:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757333AbZJFRmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 13:42:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755827AbZJFRmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 13:42:38 -0400
Date: Tue, 6 Oct 2009 10:41:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Frans Pop <elendil@planet.nl>, mingo@elte.hu, hohndel@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.32-rc3
In-Reply-To: <4ACB7F9C.9090606@s5r6.in-berlin.de>
Message-ID: <alpine.LFD.2.01.0910061040200.3432@localhost.localdomain>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
 <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <alpine.LFD.2.01.0910060828530.3432@localhost.localdomain> <200910061909.35878.elendil@planet.nl>
 <4ACB7F9C.9090606@s5r6.in-berlin.de>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Oct 2009, Stefan Richter wrote:

> Frans Pop wrote:
> > Developers are supposed to be able to take care of themselves;
> 
> _People who build kernels from sources which differ from releases_ are
> supposed to take care of themselves.

Yes. If you compile a random development kernel, you'd better then not 
come and whine to developers about how you can't tell which version it is. 
Especially when we do have things like CONFIG_LOCALVERSION_AUTO exactly 
for this case.

But it's possible that people really just weren't aware of that whole 
LOCALVERSION_AUTO thing.

			Linus
