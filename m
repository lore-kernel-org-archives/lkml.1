Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbYG2Auw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbYG2Auw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 20:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbYG2Aul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 20:50:41 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:18744 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbYG2Auk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 20:50:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dHc/G7nvXZLBLjGxp/LABxfzInLANSlVKwZ6P5sUaMOPftFFqBBAtlYcqSnH/Fv8Ry
         rIKr2oBXnnLvxK2gqCJF+PSuGJtxiz1DLkUhY457MxQ1c1f+FBdwTEPQAG/+SdOtOhZo
         hDuOj+UBL3V+UeCzIFnJ7LhNWkWiLIMEjXxvY=
Message-ID: <9e4733910807281750p52cf150lacd0e237732046e7@mail.gmail.com>
Date: Mon, 28 Jul 2008 20:50:37 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Rene Herman" <rene.herman@keyaccess.nl>
Subject: Re: 463 kernel developers missing!
Cc: "Paul Mundt" <lethal@linux-sh.org>, "James Morris" <jmorris@namei.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Dave Jones" <davej@redhat.com>, "Theodore Tso" <tytso@mit.edu>,
       "Simon Arlott" <simon@fire.lp0.eu>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <488E644D.7000507@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <488DFD97.7080802@simon.arlott.org.uk>
	 <488E1147.5040803@simon.arlott.org.uk>
	 <9e4733910807281200m25f7f16bwa6678694bb25a61@mail.gmail.com>
	 <20080728202236.GN9378@mit.edu> <20080728204624.GA11581@redhat.com>
	 <20080728141414.d7e5def2.randy.dunlap@oracle.com>
	 <Xine.LNX.4.64.0807290751510.31732@us.intercode.com.au>
	 <20080728234131.GD28055@linux-sh.org>
	 <9e4733910807281714h2918fcbey77c8d1cea902a3fd@mail.gmail.com>
	 <488E644D.7000507@keyaccess.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/28/08, Rene Herman <rene.herman@keyaccess.nl> wrote:
> On 29-07-08 02:14, Jon Smirl wrote:
>
>
> > Why do these all end in (none)?
> > Craig Hughes <craig@com.rmk.(none)>
> > Dave Neuer <dneuer@org.rmk.(none)>
> > David Brownell <david-b@net.rmk.(none)>
> > David Woodhouse <dwmw2@org.rmk.(none)>
> > Deepak Saxena <dsaxena@net.rmk.(none)>
> > Enrico Scholz <enrico.scholz@de.rmk.(none)>
> >
>
>  Because rmk rewrites addresses to comply with privacy laws. Another good
> example of why this nonsense of yours is exactly that.
>
>  I checked and am personally in there three times, once even without any
> valid email address listed. And any time there's anything other than my
> gmail address in some submission it at least recently means that someone
> _else_ took my from: address and stuck it on there and while I don't
> terribly mind that generally, I find it really annoying to see even those
> mistakes harvested into your hugely google-accessible resource.

The emails in the list are extracted from the commit log. I did not
touch the emails. If your email is in there wrong it is in a log
message wrong. That doesn't necessarily mean you are the person who
put it into the log wrong, patches can get mangled when being passed
along the maintainer chain. The point of this file is to turn the
mistake back into something useful. Think of these are reverse
mappings, they convert errors back to usable names.

As for privacy, if you don't want your email address in a file like
this don't put it into a GPL'd public project. Generate a random name
and email for each patch you submit. Of course I'm having trouble with
a Signed-off-by: that can't be turned back into a person.
Signed-off-by is there to track the responsibility chain for a patch
and if the chain has been obfuscated what good is it?

>  This is just yet another example of the senseless robotic crap people
> people just insist is "needed" and "valueable", but which is neither.
>
>  Nonsense it is.
>
>  Rene.
>


-- 
Jon Smirl
jonsmirl@gmail.com
