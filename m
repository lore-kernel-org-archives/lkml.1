Return-Path: <linux-kernel-owner+w=401wt.eu-S1760027AbYGPOrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760027AbYGPOrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 10:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757348AbYGPOrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 10:47:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43842 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122AbYGPOrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 10:47:10 -0400
Date: Wed, 16 Jul 2008 07:43:47 -0700
From: Greg KH <greg@kroah.com>
To: pageexec@freemail.hu
Cc: Tiago Assumpcao <tiago@assumpcao.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] Linux 2.6.25.10
Message-ID: <20080716144347.GB13253@kroah.com>
References: <20080716031319.GA7558@kroah.com> <487DD51F.15884.1E91CBD4@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487DD51F.15884.1E91CBD4@pageexec.freemail.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 11:01:51AM +0200, pageexec@freemail.hu wrote:
> On 15 Jul 2008 at 20:13, Greg KH wrote:
> 
> > On Tue, Jul 15, 2008 at 10:10:19PM -0300, Tiago Assumpcao wrote:
> > >
> > > All I ask for is to receive the "There are updates available." message as 
> > > soon as one security problem is reported, understood and treated by your 
> > > development part. And that is, the sooner possible, if you please.
> > 
> > Do we not already do this today?  I know I do this as soon as possible
> > for any reported problem for the -stable tree, as soon as the fix is in
> > Linus's tree.
> > 
> > See the 2.6.25.11 release for an example of this.
> 
> very good example of how you actually do *not* do what you claim. find me
> the word 'security' in your announcement. it's not there. amazing, isn't it.

No, it was a consious decision to do just to piss you off, glad to see
it worked :)

Come on, give me a break, Tiago asked that we do releases as soon as we
know about a security problem.  2.6.25.11 was released because of this,
and all users were told to upgrade.  Is the fact that I add the magic
word "security" in a sentance in the email some specific requirement
that will make you happy?

Take a look at the words I used, if someone can't determine if they
should upgrade or not based on that, then they need to rely on a company
to provide updates for them, and not be running their own kernels
because they really have no clue about system management.

Bah, what a joke.

greg k-h
