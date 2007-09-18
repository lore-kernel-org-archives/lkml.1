Return-Path: <linux-kernel-owner+w=401wt.eu-S1759481AbXIRTtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481AbXIRTtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 15:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755958AbXIRTt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 15:49:26 -0400
Received: from mail.pro-g.com.tr ([81.214.24.101]:58401 "EHLO
	mail.pro-g.com.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbXIRTtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 15:49:25 -0400
Message-ID: <46F02C3B.6030009@pro-g.com.tr>
Date: Tue, 18 Sep 2007 12:51:23 -0700
From: "Can E. Acar" <can.acar@pro-g.com.tr>
User-Agent: Thunderbird 2.0.0.5 (X11/20070729)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Theodore Tso <tytso@mit.edu>, Claudio Jeker <cjeker@diehard.n-r-g.com>,
       Adrian Bunk <bunk@kernel.org>, misc@openbsd.org,
       linux-kernel@vger.kernel.org, Daniel Hazelton <dhazelton@enter.net>,
       Eben Moglen <moglen@softwarefreedom.org>,
       Lawrence Lessig <lessig_from_web@pobox.com>,
       "Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
       Matt Norwood <norwood@softwarefreedom.org>
Subject: Re: Wasting our Freedom
References: <20070916195909.GA18232@stusta.de> <20070916203926.GA17863@schlund.de> <20070916211208.GC5502@thunk.org> <20070917125554.GB13179@diehard.n-r-g.com> <20070917133458.GA18360@thunk.org> <20070917192341.GB30119@diehard.n-r-g.com> <20070917204318.GE18360@thunk.org> <46EEFA6D.9080708@pro-g.com.tr> <20070917234726.GG18360@thunk.org> <46F01F21.4050009@pro-g.com.tr> <20070918190447.GI5386@csclub.uwaterloo.ca>
In-Reply-To: <20070918190447.GI5386@csclub.uwaterloo.ca>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> On Tue, Sep 18, 2007 at 11:55:29AM -0700, Can E. Acar wrote:
>> Well, they can add their names *anywhere* in the whole file, *except*
>> these two lines. See, these lines have a whole different meaning
>> when it comes to laws.  When they make sufficient contribution, they
>> sure can add their names. What is so difficult to understand here?
> 
> Please define "Sufficient contribution".  And in what juristiction that
> definition applies.

Please note that I am not a lawyer. It would be best if you do
your own research, and consult a lawyer.

Please look up the definition of derivative work. Even Wikipedia would
do for
some basic definitions. The copyright laws in most countries adhere to the
"Berne Convention", yet another phrase to look up.

>From my own research, one guideline I would consider is:
"The new material must be original and copyrightable in itself."

But, again, if it comes to that, the lawyers will decide and we can have
no more say on the subject.

Let me, instead tell you how we handle this when working on BSD code:
We communicate. If we feel we did some extensive changes to a file, we ask.
Get OKs from other senior developers, preferably the authors and then add
our name.

During our license audits of the OpenBSD tree, a couple of years ago, our
developers went into great pains to locate the authors and clarify
the questionable licenses that were our tree.  We are actively working
on replacing the remaining non-BSD licensed code in our tree. Not by
slapping
on our own licenses, but by asking the authors nicely to relicense, finding
replacements with an acceptable license, or by rewriting them.


Can

-- 
In theory, there is no difference between theory and practice.
But, in practice, there is.
