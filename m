Return-Path: <linux-kernel-owner+w=401wt.eu-S1758547AbZAIV7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547AbZAIV7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758615AbZAIV7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:59:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49344 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758250AbZAIV7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:59:15 -0500
Date: Fri, 9 Jan 2009 13:58:43 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Sam Ravnborg <sam@ravnborg.org>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org,
       Linux Power Management List <linux-pm@lists.osdl.org>
Subject: Re: git mv (was Re: [git pull] ACPI & Suspend patches for
 2.6.29-rc0)
In-Reply-To: <1231537636.5726.4.camel@brick>
Message-ID: <alpine.LFD.2.00.0901091357460.6528@localhost.localdomain>
References: <alpine.LFD.2.00.0901090550590.4091@localhost.localdomain>  <alpine.LFD.2.00.0901091200150.6528@localhost.localdomain>  <alpine.LFD.2.00.0901091537530.16697@localhost.localdomain>  <alpine.LFD.2.00.0901091305160.6528@localhost.localdomain> 
 <20090109212757.GA25434@uranus.ravnborg.org> <1231537636.5726.4.camel@brick>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Jan 2009, Harvey Harrison wrote:
>
> In that specific case you could just do:
> 
> gitk -- name1 name2
> 
> And that might be closer to what you're looking for.

yes. If you know the names you are interested in (and using "--follow" may 
be a way to do that), then just naming them explicitly is likely the right 
thing, because then you get the whole nice git ability to follow different 
cases across merges etc.

			Linus
