Return-Path: <linux-kernel-owner+w=401wt.eu-S1759454AbZABUT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454AbZABUT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 15:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755711AbZABUTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 15:19:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755325AbZABUTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 15:19:19 -0500
Date: Fri, 2 Jan 2009 12:18:02 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Willy Tarreau <w@1wt.eu>
cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       akpm@linux-foundation.org, rdreier@cisco.com, ian.campbell@citrix.com,
       jeremy.fitzhardinge@citrix.com, deller@gmx.de, rusty@rustcorp.com.au,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       kyle@mcmartin.ca, randolph@tausq.org, sam@ravnborg.org,
       dave@hiauly1.hia.nrc.ca
Subject: Re: [PATCH] kbuild: Disallow GCC 4.1.0 / 4.1.1
In-Reply-To: <20090102195417.GB5038@1wt.eu>
Message-ID: <alpine.LFD.2.00.0901021217390.3179@localhost.localdomain>
References: <20081231105425.9ccac21d.akpm@linux-foundation.org> <alpine.LFD.2.00.0812311318420.5086@localhost.localdomain> <20081231.141408.60544902.davem@davemloft.net> <20090102115547.GB3027@elte.hu> <alpine.LFD.2.00.0901020844070.5086@localhost.localdomain>
 <alpine.LFD.2.00.0901020933370.5086@localhost.localdomain> <20090102174641.GA27287@elte.hu> <alpine.LFD.2.00.0901020953280.5086@localhost.localdomain> <20090102180110.GA7425@elte.hu> <alpine.LFD.2.00.0901021004440.5086@localhost.localdomain>
 <20090102195417.GB5038@1wt.eu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 Jan 2009, Willy Tarreau wrote:
> 
> Yes some people (including me) still have them and are happy that there
> is a check to prevent accidental builds with an inappropriate compiler.

Heh, ok. If people really do actively have that version, let's add the 
check back in.

		Linus
