Return-Path: <linux-kernel-owner+w=401wt.eu-S1758830AbYJWXvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830AbYJWXvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 19:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbYJWXvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 19:51:07 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:47005 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbYJWXvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 19:51:06 -0400
Date: Thu, 23 Oct 2008 16:50:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       =?UTF-8?B?0JXQstCz0LXQvdC40Lkg?=
	 =?UTF-8?B?0JzQsNC90LDRh9C60LjQvQ==?= <sfstudio@mail.ru>,
       gorcunov@gmail.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [PATCH] patch to 2.6.27 fix build rpm
Message-Id: <20081023165017.66e3aa15.randy.dunlap@oracle.com>
In-Reply-To: <20081023204628.GC17600@kroah.com>
References: <20081015172412.GB20222@localhost>
	<E1KqAJK-000KWz-00.sfstudio-mail-ru@f121.mail.ru>
	<20081015184652.3a935e6f@lxorguk.ukuu.org.uk>
	<20081023204628.GC17600@kroah.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2008 13:46:28 -0700 Greg KH wrote:

> On Wed, Oct 15, 2008 at 06:46:52PM +0100, Alan Cox wrote:
> > On Wed, 15 Oct 2008 23:37:26 +0600
> > Евгений Маначкин  <sfstudio@mail.ru> wrote:
> > 
> > > From: Evgeniy Manachkin <sfstudio@mail.ru>
> > > Subject: [PATCH] mkspec - fix build rpm
> > > 
> > > This is patch to fix incorrect mkspec script to make rpm correctly at 2.6.27 vanilla kernel. This is regression in 2.6.27. 2.6.26 make rpm work good.
> > > In 2.6.27 'make rpm' say error from rpmbuild "Many unpacked files (*.fw)." 
> > > This is patch fix it this error.
> > > 
> > > Sorry my English.
> > > 
> > > Signed-off-by: Evgeniy Manachkin <sfstudio@mail.ru>
> > 
> > Acked-by: Alan Cox <alan@redhat.com>
> > 
> > This should IMHO go straight into both upstream and 2.6.27.x as it is a
> > regression fix.
> 
> This doesn't seem to have gone into Linus's tree yet, can someone please
> resend it?
> 
> Also be sure to cc: stable@kernel.org on this patch as well.

We are missing a Sam Ravnborg to merge it...

---
~Randy
