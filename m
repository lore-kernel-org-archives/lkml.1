Return-Path: <linux-kernel-owner+w=401wt.eu-S1756836AbZKWVJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836AbZKWVJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 16:09:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754782AbZKWVJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 16:09:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59332 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbZKWVJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 16:09:45 -0500
Message-ID: <4B0AFA20.9090200@suse.cz>
Date: Mon, 23 Nov 2009 22:09:52 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Sam Ravnborg <sam@ravnborg.org>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Subject: Re: Stepping down as kbuild maintainer
References: <20091120182249.GA28251@merkur.ravnborg.org> <20091121224444.GA5296@master.debian.org>
In-Reply-To: <20091121224444.GA5296@master.debian.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aníbal Monsalve Salazar napsal(a):
> On Sat, Nov 21, 2009 at 08:46:14AM +0100, Sam Ravnborg wrote:
>> On Sat, Nov 21, 2009 at 12:44:47PM +1100, Aníbal Monsalve Salazar wrote:
>>> Will you be available to answer questions while I walk the learning
>>> curve? :)
>> I will be around yes - as long as you do not expect too quick answers.
>> Good luck(*) if you decide to try it!
> 
> On Sat, Nov 21, 2009 at 09:56:39PM +0800, Américo Wang wrote:
>> On Sat, Nov 21, 2009 at 09:51:12PM +1100, Aníbal Monsalve Salazar wrote:
>>> I assume you can also help with most of the scripts. Right? :)
>> Sure, feel free to contact me if you need.
> 
> I would like to maintain kbuild.

Hi,

I would also like to maintain kbuild. Maybe we could work together? What
do you think? I already talked with Sam:

> On Mon, Nov 23, 2009 at 03:55:29PM +0100, Michal Marek wrote:
> > I would be interested / willing to take over kbuild maintainership
> > either alone or together with Aníbal who also expressed his interest. I
> > do have a linux-related job, actually kbuild-related (maintaining kernel
> > build infrastructure at a certain linux vendor) and my boss would allow
> > me to work on kbuild. I think have good experience with the kbuild
> > scripts, GNU make, perl, etc. Looking at the number of patches sent to
> > linux-kbuild, I think I should be able to manage that. And I only have
> > one kid so far ;-).
> 
> It helps enourmously if you anyway have do to some of the time consuming
> things at work.
> I suggest you and An?bal work out how to deal with stuff.
> 
> I will ocntinue to be around and can answer any questions - but the
> learning curve is maybe a bit steep in the beginning but then things
> gets easy.
> 
> And you are right - it has not been the # of patches to take care
> of. Only that to do stuff properly you should:
> - review carefully
> - test on 5+ architectures
> - and be responsive
> 
> So if you can put time aside for this a few times a week and maybe
> even the possibility to concentrate on something for more than 1 hour
> in row you should be fine.
> 
> Good luck!
> 
> 	Sam


Also, how is it supposed to work now technically - should we create a
new kbuild-{next,fixes}.git $somewhere, copy over the bits that are
currently in Sam's trees and start collecting & reviewing patches? And
once it's good enough, update the MAINTAINERS file?

Michal
