Return-Path: <linux-kernel-owner+w=401wt.eu-S1753277AbZGJDXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbZGJDXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 23:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbZGJDXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 23:23:08 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45626 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750835AbZGJDXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 23:23:07 -0400
Subject: Re: [GIT-PULL] includecheck fixes
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       David Howells <dhowells@redhat.com>, benh@kernel.crashing.org,
       paulus@samba.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       jdike@addtoit.com, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Miller <davem@davemloft.net>, dbrownell@users.sourceforge.net,
       mchehab@infradead.org, jeremy@xensource.com, felixb@sgi.com,
       lenb@kernel.org, airlied@linux.ie, bcrl@kvack.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Jiri Kosina <JKosina@novell.com>
In-Reply-To: <1247194755.2423.7.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
	 <1247164809.2452.9.camel@ht.satnam>  <20090709222626.GA32746@kroah.com>
	 <1247194755.2423.7.camel@ht.satnam>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 03:22:56 +0000
Message-Id: <1247196176.3898.158.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-10 at 08:29 +0530, Jaswinder Singh Rajput wrote:
> Hello Greg,
> 
> On Thu, 2009-07-09 at 15:26 -0700, Greg KH wrote:
> > On Fri, Jul 10, 2009 at 12:10:09AM +0530, Jaswinder Singh Rajput wrote:
> > > Linus,
> > > 
> > > Please pull includecheck fixes, these all are clean and safe patches
> > > with relevant Acks.
> > 
> > Shouldn't stuff like this go through the trivial tree?  And stuff like
> > that is relevant for the main pre-rc1 merge, not this late in the merge
> > cycle, right?
> > 
> 
> You did not specified what is your problem ? and where was you when we
> discussed it earlier ?

The problem, as you have been told several times, is that maintainers
are very busy people and don't necessarily have time to deal with
mechanical replacement trivia like this.

The point is that Jiri Kosina takes that burden on himself to verify and
submit the changes like this, so something like this should go through
him.

> Normally brain is above then the eyes, do you know why ?
> 
> To use your brain instead of follow things blindly.
> 
> The point of watching patches for some time means test and wait so that
> they can show their real faces.

Abusing people who do real work, particularly when you manifestly do
not, is a gross breach of etiquette ... welcome to my killfile.

James


