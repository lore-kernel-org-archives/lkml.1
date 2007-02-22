Return-Path: <linux-kernel-owner+w=401wt.eu-S1751696AbXBVQpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbXBVQpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 11:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbXBVQpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 11:45:38 -0500
Received: from thunk.org ([69.25.196.29]:40964 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbXBVQph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 11:45:37 -0500
Date: Thu, 22 Feb 2007 11:45:22 -0500
From: Theodore Tso <tytso@mit.edu>
To: "D. Hazelton" <dhazelton@enter.net>
Cc: "Michael K. Edwards" <medwards.linux@gmail.com>,
       David Lang <david.lang@digitalinsight.com>, davids@webmaster.com,
       v j <vj.linux@gmail.com>, trent.waddington@gmail.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>
Subject: Re: GPL vs non-GPL device drivers
Message-ID: <20070222164522.GB15659@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"D. Hazelton" <dhazelton@enter.net>,
	"Michael K. Edwards" <medwards.linux@gmail.com>,
	David Lang <david.lang@digitalinsight.com>, davids@webmaster.com,
	v j <vj.linux@gmail.com>, trent.waddington@gmail.com,
	"Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
	Neil Brown <neilb@suse.de>
References: <3d57814d0702191458l1021caeyaefd7775398c5f2a@mail.gmail.com> <200702212030.58317.dhazelton@enter.net> <f2b55d220702211805h6df0b342o7676e37c7aa43bdd@mail.gmail.com> <200702212317.16262.dhazelton@enter.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702212317.16262.dhazelton@enter.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 11:17:16PM -0500, D. Hazelton wrote:
> Since I tailor the license I apply to code I produce to meet the needs of the 
> person or entity I am writing it for, I've never run into this. In truth, the 
> LGPL is, IMHO, a piece of garbage. (as is the GPL - if you release code under 
> the GPL you no longer have a legal right to it. Note the following text that 
> appears in the GPL:
> 
> "  We protect your rights with two steps: (1) copyright the software, and
> (2) offer you this license which gives you legal permission to copy,
> distribute and/or modify the software."
> --IE: Once you release the code under the GPL, it becomes the *copyrighted* 
> *property* of the FSF and you are just another person that the GPL is applied 
> to. 

That's simply not true.  If you release the code under the GPL, you
are still the copyright holder.  You are simply using the terms of the
GPL to allow what *others* can do with your code.  So you are always
free to make it available under another license, including a
propietary one.  For example, way back when I was the only author of
all of the e2fsprogs code, I once sold a license allowing to allow the
PartitionMagic program to use portions of the e2fsprogs codebase in
their propietary Windows product; it help pay for the downpayment of
my house, too...

Now, if other people contribute code to your project, and you accept
it without a copyright assignment, then their code is generally
presumed to be implicitly licensed under the same license as the
original program, and so that would presumably restrict your ability
to relicense the project without getting their permission as well,
since some of the code or documentation is theirs.

The only way GPL'ed code can be become copyrighted by the FSF is if
you explicitly sign a copyright statement (and before you do that,
take a very close look at the FSF copyright assignment letter, and if
you don't know what "indemnify" menas, and have any kind of
significant assets, such as a house, or anticipate having significant
assets in the future, run, don't walk, to a lawyer and talk to them
first), or if you explicitly release the code into the public domain
and then they grab it and make some changes which are copyrighted by
the FSF.   

But saying that just by licensing your code under the GPL means that
the FSF owns your code?  That's just crazy talk.

						- Ted
