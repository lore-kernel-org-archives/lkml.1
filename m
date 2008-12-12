Return-Path: <linux-kernel-owner+w=401wt.eu-S1757236AbYLLHy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbYLLHy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 02:54:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750870AbYLLHyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 02:54:18 -0500
Received: from 8bytes.org ([88.198.83.132]:51305 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbYLLHyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 02:54:18 -0500
Date: Fri, 12 Dec 2008 08:54:15 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, dhowells@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.28-rc8
Message-ID: <20081212075414.GF24323@8bytes.org>
References: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain> <24401.1229009346@redhat.com> <20081211.191949.05090709.davem@davemloft.net> <alpine.LFD.2.00.0812112138510.3340@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812112138510.3340@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 09:40:21PM -0800, Linus Torvalds wrote:
> 
> 
> On Thu, 11 Dec 2008, David Miller wrote:
> 
> > From: David Howells <dhowells@redhat.com>
> > Date: Thu, 11 Dec 2008 15:29:06 +0000
> > 
> > > Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > > 
> > > >  (a) just make the -rc's go on a few more weeks, and do 2.6.28 after xmas
> > > > 
> > > >      I like this, because alledgely people are debugging things, and we'd 
> > > >      get a more stable 2.6.28.
> > > 
> > > Which would perhaps mean that the merge window is open during LCA, which will
> > > be inconvenient for some people.  On the other hand, it might put the culprits
> > > where you can lay your hands on them.
> > 
> > That happened in Melbourne and it wasn't pleasant.  Instead
> > of enjoying talks at the conference some of us were stressing
> > out on our laptops dealing with our merges instead.
> 
> Yes. I definitely want to close the 29 merge window before LCA. In fact, I 
> want to close it far enough before that we can fix up any worst issues.
> 
> Which does argue for opening it up during the holidays, I guess.

You can do a release around 29th/30th December. This gives the people
who are on vacation until the new year still a week for merging stuff
and the merge window closes 4-5 days before people are leaving for
LCA.

Joerg

