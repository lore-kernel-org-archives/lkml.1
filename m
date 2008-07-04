Return-Path: <linux-kernel-owner+w=401wt.eu-S1755411AbYGDWgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbYGDWgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 18:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbYGDWgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 18:36:39 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:55161 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211AbYGDWgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 18:36:38 -0400
Subject: Re: [PATCH] OProfile kernel maintainership changes
From: Richard Purdie <rpurdie@openedhand.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robert Richter <robert.richter@amd.com>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>, Philippe Elie <phil.el@wanadoo.fr>,
       John Levon <levon@movementarian.org>,
       Maynard Johnson <maynardj@us.ibm.com>,
       Daniel Hansel <daniel.hansel@linux.vnet.ibm.com>,
       Jason Yeh <jason.yeh@amd.com>
In-Reply-To: <20080704120942.ed671ce2.akpm@linux-foundation.org>
References: <1215197619-28982-1-git-send-email-robert.richter@amd.com>
	 <20080704120942.ed671ce2.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 04 Jul 2008 23:36:34 +0100
Message-Id: <1215210995.8410.29.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-04 at 12:09 -0700, Andrew Morton wrote:
> On Fri, 4 Jul 2008 20:53:39 +0200 Robert Richter <robert.richter@amd.com> wrote:
> 
> > Cc: Philippe Elie <phil.el@wanadoo.fr>
> > Cc: John Levon <levon@movementarian.org>
> > Cc: Maynard Johnson <maynardj@us.ibm.com>
> > Cc: Richard Purdie <rpurdie@openedhand.com>
> > Cc: Daniel Hansel <daniel.hansel@linux.vnet.ibm.com>
> > Cc: Jason Yeh <jason.yeh@amd.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Robert Richter <robert.richter@amd.com>
> > ---
> >  MAINTAINERS |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index e6c06fa..85a7e4a 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -3080,8 +3080,8 @@ L:	linux-scsi@vger.kernel.org
> >  S:	Maintained
> >  
> >  OPROFILE
> > -P:	Philippe Elie
> > -M:	phil.el@wanadoo.fr
> > +P:	Robert Richter
> > +M:	robert.richter@amd.com
> >  L:	oprofile-list@lists.sf.net
> >  S:	Maintained
> 
> Well that's interesting - please tell us more?
> 
> Will you also have a role in oprofile userspace maintenance?

OProfile maintainership is undergoing some transitions as announced by
John on the oprofile list earlier today. 

In summary, Maynard is taking over the overall control of oprofile
userspace with Daniel advising on the JIT stuff and me taking on
responsibility for the arm kernel+userspace bits and the userspace GUI
bits. Robert has volunteered to take a role of looking after the kernel
side of things alongside or replacing Philippe depending on how he feels
about this - I'm not 100% clear on Philippe's position on things. John
will still be around to keep an eye on us all :).

Cheers,

Richard


