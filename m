Return-Path: <linux-kernel-owner+w=401wt.eu-S1754246AbZAFWMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbZAFWMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750906AbZAFWMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:12:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750836AbZAFWMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:12:06 -0500
Date: Tue, 6 Jan 2009 14:11:43 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesper Nilsson <jesper.nilsson@axis.com>
Subject: Re: [PATCH 03/23] cris: introduce asm/swab.h
In-Reply-To: <1231279452.25147.1.camel@brick>
Message-ID: <alpine.LFD.2.00.0901061409270.3057@localhost.localdomain>
References: <1231277446.964.260.camel@brick>  <alpine.LFD.2.00.0901061357150.3057@localhost.localdomain> <1231279452.25147.1.camel@brick>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Jan 2009, Harvey Harrison wrote:
> 
> Sure, I sent regular patches as a courtesy to Andrew in case he slurped
> it up, but I can resend with -M -B if you're going to take it directly,
> should I wait until I see the remaining 4 arches hit your tree, or will
> you worry about the timing?

I'm not sure worrying about the timing makes much sense, since the bigger 
worry is wanting to merge things in time for -rc1 - and that means having 
a few days to catch any gotcha's. If parisc/xtensa/cris is broken for a 
day or two, I don't consider that a problem. 

		Linus
