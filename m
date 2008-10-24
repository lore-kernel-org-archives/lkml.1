Return-Path: <linux-kernel-owner+w=401wt.eu-S1758510AbYJXXOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510AbYJXXOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 19:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757881AbYJXXOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 19:14:06 -0400
Received: from pqueuea.post.tele.dk ([193.162.153.9]:41486 "EHLO
	pqueuea.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266AbYJXXOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 19:14:04 -0400
X-Greylist: delayed 1675 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Oct 2008 19:14:04 EDT
Date: Fri, 24 Oct 2008 08:04:06 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       =?utf-8?B?0JXQstCz0LXQvdC40Lkg0JzQsNC90LDRh9C60LjQvQ==?= 
	<sfstudio@mail.ru>,
       gorcunov@gmail.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [PATCH] patch to 2.6.27 fix build rpm
Message-ID: <20081024060406.GA8260@uranus.ravnborg.org>
References: <20081015172412.GB20222@localhost> <E1KqAJK-000KWz-00.sfstudio-mail-ru@f121.mail.ru> <20081015184652.3a935e6f@lxorguk.ukuu.org.uk> <20081023204628.GC17600@kroah.com> <20081023165017.66e3aa15.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081023165017.66e3aa15.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 04:50:17PM -0700, Randy Dunlap wrote:
> On Thu, 23 Oct 2008 13:46:28 -0700 Greg KH wrote:
> 
> > On Wed, Oct 15, 2008 at 06:46:52PM +0100, Alan Cox wrote:
> > > On Wed, 15 Oct 2008 23:37:26 +0600
> > > Евгений Маначкин  <sfstudio@mail.ru> wrote:
> > > 
> > > > From: Evgeniy Manachkin <sfstudio@mail.ru>
> > > > Subject: [PATCH] mkspec - fix build rpm
> > > > 
> > > > This is patch to fix incorrect mkspec script to make rpm correctly at 2.6.27 vanilla kernel. This is regression in 2.6.27. 2.6.26 make rpm work good.
> > > > In 2.6.27 'make rpm' say error from rpmbuild "Many unpacked files (*.fw)." 
> > > > This is patch fix it this error.
> > > > 
> > > > Sorry my English.
> > > > 
> > > > Signed-off-by: Evgeniy Manachkin <sfstudio@mail.ru>
> > > 
> > > Acked-by: Alan Cox <alan@redhat.com>
> > > 
> > > This should IMHO go straight into both upstream and 2.6.27.x as it is a
> > > regression fix.
> > 
> > This doesn't seem to have gone into Linus's tree yet, can someone please
> > resend it?
> > 
> > Also be sure to cc: stable@kernel.org on this patch as well.
> 
> We are missing a Sam Ravnborg to merge it...

Back online as of yesterday.
Please resend patch to me.

	Sam
