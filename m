Return-Path: <linux-kernel-owner+w=401wt.eu-S934193AbYB2V4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934193AbYB2V4b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 16:56:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761618AbYB2V4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 16:56:22 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:38056 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761611AbYB2V4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 16:56:21 -0500
Date: Fri, 29 Feb 2008 23:55:00 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Zan Lynx <zlynx@acm.org>, Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Roskin <proski@gnu.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use GPL-only
	symbols
Message-ID: <20080229215500.GA25835@cs181133002.pp.htv.fi>
References: <1204236662.3612.6.camel@dv> <alpine.LFD.1.00.0802281525170.5780@woody.linux-foundation.org> <20080229012012.ajlsk4pow8wkkgss@webmail.spamcop.net> <alpine.LFD.1.00.0802290807110.17889@woody.linux-foundation.org> <1204304352.6767.21.camel@localhost> <1204305492.3501.83.camel@jcmlaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1204305492.3501.83.camel@jcmlaptop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 12:18:12PM -0500, Jon Masters wrote:
>...
> *). Keep this patch. And potentially add some more for other similar
> shim layers - I can think of a certain graphics driver that might
> qualify for similar treatment, if one wants to go there. But I might
> need to find a tailor specializing in *really* fire retardant pants
> before I think of being the one who submits that patch.
>...

If all that's missing for getting such a patch included is submitting it 
I would even do it with my normal pants on. [1]

I would leave the *really* fire retardant pants for the case that 
someone will ever try some "are binary modules legal" case at court by 
suing people operating ftp mirrors of Debian non-free and similar
repositories of other distributions... [2,3]

> Jon.
>...

cu
Adrian

[1] no matter whether in the British or the American meaning of "pants"
[2] realistically, if these things will ever go to court, the person 
    suing might not want to choose some billion Dollar US company
    but some local private person or university as defendant
[3] like e.g. Caldera turning into SCO and a Linux developer fired by 
    Novell yesterday being hired by Microsoft tomorrow life changes 
    fast, and one of the many copyright holders of the kernel might some 
    day find some reason why he wants to do this

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

