Return-Path: <linux-kernel-owner+w=401wt.eu-S1751406AbYEESN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406AbYEESN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbYEESNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:13:18 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:60303 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbYEESNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:13:18 -0400
Date: Mon, 5 May 2008 21:12:10 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: SL Baur <steve@xemacs.org>, linux-kernel@vger.kernel.org
Subject: Re: How to reduce the number of open kernel bugs
Message-ID: <20080505181210.GB17139@cs181133002.pp.htv.fi>
References: <20080502124210.GB5838@cs181133002.pp.htv.fi> <ed10ee420805030313r457d8cdfjdbcb346ae928c125@mail.gmail.com> <20080503112118.GK5838@cs181133002.pp.htv.fi> <481C881D.4010708@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <481C881D.4010708@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2008 at 05:43:25PM +0200, Stefan Richter wrote:
>
> Adrian, what is it that you criticize?  Was it an impolite tone in the  
> maintainer's responses, or do you believe that the maintainer lied to  
> the reporter?
> 
> Or did the maintainer miss to do something which he would be able to and  
> had the resources to do?
>
> Or did the maintainer refuse to fulfill an obligation?
> 
> If it is one of the latter points, is it that the maintainer failed,  
> according to your observation, to explain in more detail why he closed  
> the bug early, in a way that a person without deep technical insight  
> into the problem domain can parse?  Or to ask for information which  
> would bring the bug forward?  Or to analyze the problem deeper on his  
> own?  Or use the bugzilla system in a more sophisticated way (reassign,  
> set status, change title... instead of closing the bug and requiring the  
> reporter to create a different bug entry)?
>...

The only thing that was really bad was the tone.

When anyone says "he could anyway not done anything about the bug" 
that's not true since he e.g. noted himself APIC errors in the report,
and could have reassigned the bug accordingly. Or noted it in the 
bug - when I touch a bug (as I did with this one before) I'm putting 
myself to the Cc, and I read what happens later in the bug.

But that's not the problem. The problem was the (repeated) closing of a 
bug in a way that expresses to a submitter that bug reports were 
unwanted.

> Stefan Richter

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

