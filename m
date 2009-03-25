Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbZCYTY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbZCYTY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 15:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbZCYTYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 15:24:49 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:36262 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbZCYTYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 15:24:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cH3gBCM/3Sjkrz2731ZHEcxWn1ovp9W+6zTgRXVHeAI0v6DbuMsCRNwUCi2hvqFWVu
         kKssSVSzQZtS8iGQFI76fLJVwNtk06iad8xbOuXq5ZYT6DNY+J2Vnq+a4GqHOOR96Yew
         aJZfypZwr5UrQielL3iSEHqtysr7jwBVON/q0=
Date: Wed, 25 Mar 2009 20:24:43 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Credit for vsprintk work
Message-ID: <20090325192439.GG5932@nowhere>
References: <alpine.DEB.2.00.0903250949420.5675@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903250949420.5675@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 09:58:52AM -0400, Steven Rostedt wrote:
> 
> Frederic,
> 
>  $ git blame lib/vsprintf.c |grep 'Frederic Weisbecker' | wc -l
> 542
> 
> You did a hell of a lot of work on vsprintf.c, and you are still too 
> modest to put in a copyright at the top.
> 
> I know some people think that git is good enough for ownership. But 
> really, the amount of changes that you did in vsprintf.c deserves a bit of 
> credit in the source file.
> 
> Is everyone OK if a copyright goes at the top of this file giving credit 
> to Frederic?  If for anything else, it will facilitate people to find who 
> broke it if it breaks ;-)
> 
> I think Frederic should send one more patch to add his copyright. That is, 
> of course, if Frederic wants too.
> 
> Note, Frederic did not ask me to post this. In fact, this is the first 
> time he's seen this complaint. I'm posting this because I was showing this 
> code to some students at a University and when I wanted to point out 
> who wrote it, I was surprised that Frederic's name was not mentioned.
> I was looking at the code via LXR so git was not helpful here.
> 
> -- Steve
> 


:-)

Ok, so if nobody is opposite to, I will send a patch for that.
Lai, no problem with me adding your copyright too?

Thanks!

