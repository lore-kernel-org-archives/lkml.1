Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbXFUXZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbXFUXZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 19:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbXFUXZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 19:25:36 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:39221
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbXFUXZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 19:25:36 -0400
Date: Thu, 21 Jun 2007 16:25:48 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
cc: schilling@fokus.fraunhofer.de, linux-kernel@vger.kernel.org
Subject: Re: Linux Kernel include files
In-Reply-To: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de>
Message-ID: <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007, Joerg Schilling wrote:

> Is there some hope that at least the Linux kernel interface definition files and
> everything recursively included from these files will be rewritten in vanilla
> ANSI C?

this has been discussed many times and the answer is that the kernel is 
not gong to change it's side of things to ANSI C.

that doesn't mean that one of the many projects out there to create 
seperate interface headers won't do this.

however, there is another interesting thing going on at the moment. The 
standards commity is currently deciding what will be in the next rev of 
the C specs (tentitivly labels C1x for discussions, they are hopeing to 
release them in '09 or '10)

some of the things that are GCC extentions are going to be added to the 
spec (ahtough possibly with a change to the syntax)

so now is the time to talk to your local reps who go to these meetings and 
make your suggestions for what should be added to the standard and what 
should not be.

remember that anything to be added must be implemented somehwere, 
preferrably by multiple seperate compilers.

David Lang
