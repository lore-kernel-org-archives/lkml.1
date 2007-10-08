Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919AbXJHXGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbXJHXGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 19:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbXJHXGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 19:06:09 -0400
Received: from barikada.upol.cz ([158.194.242.200]:52312 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbXJHXGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 19:06:08 -0400
To: Theodore Tso <tytso@mit.edu>, Jonathan Corbet <corbet@lwn.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jan Engelhardt <jengelh@computergmbh.de>,
       Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: RFC: reviewer's statement of oversight
In-Reply-To: <20071008213852.GA31713@thunk.org>
References: <25555.1191864285@lwn.net> <20071008173706.GA12026@uranus.ravnborg.org> <Pine.LNX.4.64.0710081939120.10239@fbirervta.pbzchgretzou.qr> <470A9422.4050400@zytor.com> <20071008213852.GA31713@thunk.org>
User-Agent: slrn + jed (x86_64-pc-linux-glibc-debian)
Date: Tue, 9 Oct 2007 01:20:17 +0200
Message-Id: <E1If1tZ-0002h7-UU@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Mon, 8 Oct 2007 17:38:52 -0400
>
> On Mon, Oct 08, 2007 at 01:33:38PM -0700, H. Peter Anvin wrote:
>> Uhm, no.  There is no reason an "unimportant" person couldn't review a 
>> patch, and therefore perform a potentially highly valuable service to 
>> the maintainer.
>> 
>> None of these are indicative of the authority of the person acking, 
>> reviewing, testing, or nacking.  That's only as good as the trust in the 
>> person signing.
>
> I would tend to agree.  Right now I think the problem is that we are
> getting too little reviews, not enough.  And someone who reviews
> patches, even if unknown, could be building up expertise that
> eventually would make them a valued developer, even while they are
> doing us a service.   

Experience of convincing experienced patch author, that some things in
the patch are wrong :)

[]
> We could ask reviewers to include a URL to an LKML archive of their
> review, to make it easier to find a review of a patch so later on
> people can judge how effective they their review was.

I vote for more little summaries in the `Subject'(again). Long, boring
threads with whole threading part of screen being empty due to same
subjects isn't fun, when some of thousands of messages can have
interesting stuff inside.

And it's easy not only for mailing list readers now, and for archive
readers also; readers of the www search results (who ever that may be):

google.com/search?q=reviewed+crashkernel

First hit on the review of the patch, i happened to make. And i just
thought "hell, just string parsing, what can be more simply?", yet there
was productive discussion and bug fixing. After i saw convincing
statements about testing, i've placed review mark. Though i'm really
"unimportant" random hacker.
--
-o--=O`C
 #oo'L O
<___=E M
