Return-Path: <linux-kernel-owner+w=401wt.eu-S965197AbXDKTZC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965197AbXDKTZC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 15:25:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965211AbXDKTZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 15:25:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38421 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965197AbXDKTZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 15:25:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.21-rc6-mm1
Date: Wed, 11 Apr 2007 21:28:26 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, lenb@kernel.org,
       Adam Belay <abelay@novell.com>
References: <653FFBB4508B9042B5D43DC9E18836F539ADFB@scsmsx415.amr.corp.intel.com> <200704091940.53439.rjw@sisk.pl> <20070410222009.GA26607@linux-os.sc.intel.com>
In-Reply-To: <20070410222009.GA26607@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704112128.27176.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 11 April 2007 00:20, Venki Pallipadi wrote:
> On Mon, Apr 09, 2007 at 07:40:52PM +0200, Rafael J. Wysocki wrote:
> > On Monday, 9 April 2007 18:14, Pallipadi, Venkatesh wrote:
> > > 
> > > >-----Original Message-----
> > > >From: Rafael J. Wysocki [mailto:rjw@sisk.pl] 
> > > >Sent: Monday, April 09, 2007 9:08 AM
> > > >To: Andrew Morton
> > > >Cc: linux-kernel@vger.kernel.org; randy.dunlap@oracle.com; 
> > > >lenb@kernel.org; Pallipadi, Venkatesh
> > > >Subject: Re: 2.6.21-rc6-mm1
> > > >
> > > >On Sunday, 8 April 2007 23:35, Andrew Morton wrote:
> > > >> 
> > > >> 
> > > >ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2
> > > >.6.21-rc6/2.6.21-rc6-mm1/
> > > >> 
> > > >> 
> > > >> - Lots of x86 updates
> > > >> 
> > > >> - This is a 25MB diff against mainline, which is rather large.
> > > >
> > > >The cpuidle thing tends to hang my x86-64 machines on boot.
> > > >
> > > 
> > > Hi Rafael,
> > > 
> > > At what point during boot does it hang?
> > 
> > When mounting the root filesystem.  It hangs completely, even the magic SysRq
> > doesn't work
> > 
> 
> Rafael: Below patch should fix the hang.

Yes, the box boots now, thanks.

Greetings,
Rafael
