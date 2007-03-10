Return-Path: <linux-kernel-owner+w=401wt.eu-S1767605AbXCJAQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767605AbXCJAQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 19:16:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767674AbXCJAQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 19:16:46 -0500
Received: from holomorphy.com ([66.93.40.71]:46229 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767605AbXCJAQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 19:16:45 -0500
Date: Fri, 9 Mar 2007 16:16:48 -0800
From: William Lee Irwin III <wli@holomorphy.com>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Pluggable Schedulers (was: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler)
Message-ID: <20070310001648.GF2986@holomorphy.com>
References: <200703091625.55361.a1426z@gawab.com> <20070309135751.GE2986@holomorphy.com> <200703092343.46276.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703092343.46276.a1426z@gawab.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
>> The short translation of my message for you is "Linus, please don't
>> LART me too hard."

On Fri, Mar 09, 2007 at 11:43:46PM +0300, Al Boldi wrote:
> Right.

Given where the code originally came from, I've got bullets to dodge.


William Lee Irwin III wrote:
>> This sort of concern is too subjective for me to have an opinion on it.

On Fri, Mar 09, 2007 at 11:43:46PM +0300, Al Boldi wrote:
> How diplomatic.

Impoliteness doesn't accomplish anything I want to do.


William Lee Irwin III wrote:
>> My preferred sphere of operation is the Manichean domain of faster vs.
>> slower, functionality vs. non-functionality, and the like. For me, such
>> design concerns are like the need for a kernel to format pagetables so
>> the x86 MMU decodes what was intended, or for a compiler to emit valid
>> assembly instructions, or for a programmer to write C the compiler
>> won't reject with parse errors.

On Fri, Mar 09, 2007 at 11:43:46PM +0300, Al Boldi wrote:
> Sure, but I think, even from a technical point of view, competition is a good 
> thing to have.  Pluggable schedulers give us this kind of competition, that 
> forces each scheduler to refine or become obsolete.  Think evolution.

I'm more of a cooperative than competitive person, not to say that
flies well in Linux. There are more productive uses of time than having
everyone NIH'ing everyone else's code. If the result isn't so great,
I'd rather send them code or talk them about what needs to be done.


William Lee Irwin III wrote:
>> If Linus, akpm, et al object to the
>> design, then invalid output was produced. Please refer to Linus, akpm,
>> et al for these sorts of design concerns.

On Fri, Mar 09, 2007 at 11:43:46PM +0300, Al Boldi wrote:
> Point taken.

Decisions with respect to overall kernel design are made from well
above my level. Similarly with coding style, release management, code
directory hierarchy, nomenclature, and more. These things are Linus'
and devolved to those who go along with him on those fronts. If I
made those decisions, you might as well call it "wlix" not "Linux."


Linus Torvalds wrote:
>> And hey, you can try to prove me wrong. Code talks. So far, nobody has
>> really ever come close.
>> So go and code it up, and show the end result. So far, nobody who actually
>> *does* CPU schedulers have really wanted to do it, because they all want
>> to muck around with their own private versions of the data structures.

On Fri, Mar 09, 2007 at 11:43:46PM +0300, Al Boldi wrote:
> What about PlugSched?

The extant versions of it fall well short of Linus' challenge as well
as my original goals for it. A useful exercise may also be enumerating
your expectations and having those who actually work with the code
describe how well those are actually met.


-- wli
