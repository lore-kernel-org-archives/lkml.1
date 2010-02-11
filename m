Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab0BKQza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 11:55:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41035 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680Ab0BKQz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 11:55:29 -0500
Date: Thu, 11 Feb 2010 08:54:55 -0800
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Scott Smedley <ss@aao.gov.au>
Subject: Re: linux-next: Tree for December 19 (staging/dt3155)
Message-ID: <20100211165455.GB28084@suse.de>
References: <20091219110457.d6c5de1f.sfr@canb.auug.org.au>
 <20091218191037.d6b4727b.randy.dunlap@oracle.com>
 <20091219044747.GB14503@suse.de>
 <20100211084430.5fd5afbb.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100211084430.5fd5afbb.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 08:44:30AM -0800, Randy Dunlap wrote:
> On Fri, 18 Dec 2009 20:47:47 -0800 Greg KH wrote:
> 
> > On Fri, Dec 18, 2009 at 07:10:37PM -0800, Randy Dunlap wrote:
> > > On Sat, 19 Dec 2009 11:04:57 +1100 Stephen Rothwell wrote:
> > > 
> > > > Hi all,
> > > > 
> > > > I said:
> > > > > News:  there will be no linux-next releases until at least Dec 24 and,
> > > > > more likely, Dec 29.  Have a Merry Christmas and take a break.  :-)
> > > > 
> > > > Well, I decided I had time for one more so it will be based in -rc1).
> > > > 
> > > > This one has not had the build testing *between* merges, but has had all
> > > > the normal build testing at the end.  Since the latter testing showed no
> > > > problems, this just means that there may be more unbisectable points in
> > > > the tree (but that is unlikely).
> > > 
> > > 
> > > When CONFIG_DT3155=y (i.e., not a loadable module):
> > 
> > Ick, I'll change that to 'M' now, it shouldn't be built in just yet for
> > the reasons you found.
> > 
> > I don't think the code has ever been built as 'y' as you just found out.
> 
> Greg,
> Did you get around to making any of these changes?

I have started working on them, but have not gotten to all of them yet.

thanks for your patience,

greg k-h
