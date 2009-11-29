Return-Path: <linux-kernel-owner+w=401wt.eu-S1752618AbZK2HJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbZK2HJL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 02:09:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbZK2HJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 02:09:10 -0500
Received: from master.debian.org ([70.103.162.29]:32990 "EHLO
	master.debian.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbZK2HJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 02:09:09 -0500
Date: Sun, 29 Nov 2009 18:09:03 +1100
From: =?iso-8859-1?Q?An=EDbal?= Monsalve Salazar <anibal@debian.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Sam Ravnborg <sam@ravnborg.org>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Subject: Re: Stepping down as kbuild maintainer
Message-ID: <20091129070903.GA3843@master.debian.org>
Mail-Followup-To: Michal Marek <mmarek@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kbuild <linux-kbuild@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Sam Ravnborg <sam@ravnborg.org>,
	=?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
References: <20091120182249.GA28251@merkur.ravnborg.org>
 <20091121224444.GA5296@master.debian.org>
 <4B0AFA20.9090200@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B0AFA20.9090200@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 10:09:52PM +0100, Michal Marek wrote:
>I would also like to maintain kbuild. Maybe we could work together?
>What do you think? I already talked with Sam:

(Sorry, I've been very busy with my Real Life. :)

Sure. I agree. I'll test the patches on my machines (i386, x86_64,
sparc64, powerpc, armel, alpha, and mips) and reply to them timely.

>>On Mon, Nov 23, 2009 at 03:55:29PM +0100, Michal Marek wrote:
>>>I would be interested / willing to take over kbuild maintainership
>>>either alone or together with Aníbal who also expressed his interest.
>>>I do have a linux-related job, actually kbuild-related (maintaining
>>>kernel build infrastructure at a certain linux vendor) and my boss
>>>would allow me to work on kbuild. I think have good experience with
>>>the kbuild scripts, GNU make, perl, etc. Looking at the number of
>>>patches sent to linux-kbuild, I think I should be able to manage
>>>that. And I only have one kid so far ;-).
>>
>>It helps enourmously if you anyway have do to some of the time
>>consuming things at work.
>>
>>I suggest you and Anibal work out how to deal with stuff.
>>
>>I will continue to be around and can answer any questions - but the
>>learning curve is maybe a bit steep in the beginning but then things
>>gets easy.
>>
>>And you are right - it has not been the # of patches to take care of.
>>Only that to do stuff properly you should:
>>- review carefully
>>- test on 5+ architectures
>>- and be responsive
>>
>>So if you can put time aside for this a few times a week and maybe
>>even the possibility to concentrate on something for more than 1 hour
>>in row you should be fine.

I agree with Sam too.

On Fri, Nov 27, 2009 at 03:22:11PM +1100, Stephen Rothwell wrote:
>You will need to ensure that the patches/commits in your tree/series
>have been:
>    * submitted under GPL v2 (or later) and include the Contributor's
>      Signed-off-by,
>    * posted to the relevant mailing list,
>    * reviewed by you (or another maintainer of your subsystem tree),
>    * successfully unit tested, and
>    * destined for the current or next Linux merge window.
>
>Basically, this should be just what you would send to Linus (or ask him
>to fetch).  It is allowed to be rebased if you deem it necessary.

And with Stephen as well.
