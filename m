Return-Path: <linux-kernel-owner+w=401wt.eu-S1758766AbZBEScp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766AbZBEScp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 13:32:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759961AbZBEScG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 13:32:06 -0500
Received: from tomts20.bellnexxia.net ([209.226.175.74]:37123 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759748AbZBEScC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 13:32:02 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsIEAEO+iklMQWt2/2dsb2JhbACBbs8IhBYG
Date: Thu, 5 Feb 2009 13:31:59 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Trilok Soni <soni.trilok@gmail.com>, ltt-dev@lists.casi.polymtl.ca,
       Ext4 Developers List <linux-ext4@vger.kernel.org>,
       "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] LTTng 0.89 for Linux 2.6.29-rc3
Message-ID: <20090205183158.GA1969@Krystal>
References: <20090130200757.GA14999@Krystal> <20090205140432.GE6915@linux.vnet.ibm.com> <20090205150242.GA27895@Krystal> <20090205151841.GF6915@linux.vnet.ibm.com> <20090205153825.GA30255@Krystal> <20090205155854.GG6915@linux.vnet.ibm.com> <5d5443650902050822r2e4d08ffg2322b45a5e009fb8@mail.gmail.com> <20090205180132.GJ6915@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090205180132.GJ6915@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:30:30 up 35 days, 18:28,  3 users,  load average: 0.12, 0.25,
	0.18
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Thu, Feb 05, 2009 at 09:52:16PM +0530, Trilok Soni wrote:
> > Hi Paul,
> > 
> > On Thu, Feb 5, 2009 at 9:28 PM, Paul E. McKenney
> > <paulmck@linux.vnet.ibm.com> wrote:
> > >>
> > >> Are you using quilt to apply the patchset series file in the right order ?
> > >
> > > Ummm...  No.  I never have used quilt.
> > >
> > > Ah, there is a series file.  I guess it would not be too hard to make
> > > an appropriate "sh" command:
> > 
> > How about trying?
> > 
> > #quilt push -a
> 
> Is the appropriate incantation as follows?
> 
> 	cd <top of git tree>
> 	mkdir patches
> 	cp /tmp/patch-2.6.29-rc3-lttng-0.92/* patches
> 	quilt push -a
> 

Yes, exactly.

And from there you can follow the LTTng manual here :

http://ltt.polymtl.ca/svn/trunk/lttv/LTTngManual.html

Mathieu

> 							Thanx, Paul
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
