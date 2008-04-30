Return-Path: <linux-kernel-owner+w=401wt.eu-S1764664AbYD3TXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764664AbYD3TXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 15:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762300AbYD3TWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 15:22:53 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:54447 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761509AbYD3TWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 15:22:52 -0400
Date: Wed, 30 Apr 2008 22:22:08 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: Willy Tarreau <w@1wt.eu>, "H. Peter Anvin" <hpa@kernel.org>,
       linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
Message-ID: <20080430192208.GE29330@cs181133002.pp.htv.fi>
References: <20080428154023.GU2813@cs181133002.pp.htv.fi> <20080428230524.GK8474@1wt.eu> <48167A07.4000305@kernel.org> <20080429050605.GA27875@1wt.eu> <20080429072911.GA28059@cs181133002.pp.htv.fi> <20080429081423.GD30507@1wt.eu> <4816E4FD.5060605@aitel.hist.no> <20080429100934.GB1473@1wt.eu> <481838A0.2060507@aitel.hist.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <481838A0.2060507@aitel.hist.no>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 11:15:12AM +0200, Helge Hafting wrote:
> Willy Tarreau wrote:
>...
>> It's too easy to impose crappy designs to end-users and tell them that if
>> that does not work they have to file a bug. There are a minimal set of
>> things that must be tested before shipping. Seeing that the default
>> terminal emulator in KDE on Mandriva 2008 is configured in UTF-8 and does
>> not properly render it simply makes me sick. This is broken by design and
>> even distros trying to get it working for years still can't cope with it.
>> There must be a reason.
>>   
> Yeah, ascii-only is a crappy design. :-/ I don't know if mandriva is 
> broken by design - I only use debian.
> It would not surprise me if some distros  botch utf-8 through negligence.
> They are based in english-speaking countries and have their biggest
> user bases there - the majority of their customers aren't going to use  
> more than
> ascii so why should they bother. 

Mandriva is a French company.

And what Willy describes really sounds like someone fiddling with some 
settings (or something like accidentally selecting some non UTF-8 
locale).

Bad things can happen when you somehow get charsets mixed, but 
distributions default to UTF-8 for quite some time, and problems
with a 100% UTF-8 system have therefore become were unlikely.

>...
> Helge Hafting

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

