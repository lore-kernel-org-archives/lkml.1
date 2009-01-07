Return-Path: <linux-kernel-owner+w=401wt.eu-S1755539AbZAGFim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbZAGFim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 00:38:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756628AbZAGFi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 00:38:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58211 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756024AbZAGFi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 00:38:27 -0500
Date: Tue, 6 Jan 2009 21:38:21 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Nicolas Pitre <nico@cam.org>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: powerpc: introduce asm/swab.h
In-Reply-To: <alpine.LFD.2.00.0901070024410.26118@xanadu.home>
Message-ID: <alpine.LFD.2.00.0901062137520.3057@localhost.localdomain>
References: <200901070400.n0740Ore002063@hera.kernel.org> <1231303340.14860.61.camel@pasglop> <1231304552.14860.72.camel@pasglop> <alpine.LFD.2.00.0901062108440.3057@localhost.localdomain> <alpine.LFD.2.00.0901070017550.26118@xanadu.home>
 <alpine.LFD.2.00.0901070024410.26118@xanadu.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Jan 2009, Nicolas Pitre wrote:
> 
> Well, given that I have no way to test any code path including 
> be64_to_cpu() and its opposite, my testing is only valid for 
> compilation issues.

Thinking about it, there's probably not a whole lot of users. If any.

So if it compiles, I guess it's good ;)

		Linus
