Return-Path: <linux-kernel-owner+w=401wt.eu-S1758165AbYFVVTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165AbYFVVTe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 17:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756028AbYFVVT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 17:19:26 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:54474 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755764AbYFVVT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 17:19:26 -0400
Date: Mon, 23 Jun 2008 00:17:34 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adam Williamson <awilliamson@mandriva.com>, Alan Cox <alan@redhat.com>,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug #10868] Oops on loading ipaq module since 2.6.26,
	prevents use of device
Message-ID: <20080622211734.GE20122@cs181140183.pp.htv.fi>
References: <RzbtSgMztjP.A.jRD._spXIB@albercik> <4mRZUF-hVeG.A.s6E.JupXIB@albercik> <20080622210706.0a90c4ba@lxorguk.ukuu.org.uk> <20080622140044.57dce6f2@infradead.org> <20080622140226.5a54de90@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080622140226.5a54de90@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2008 at 02:02:26PM -0700, Arjan van de Ven wrote:
> On Sun, 22 Jun 2008 14:00:44 -0700
> Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > On Sun, 22 Jun 2008 21:07:06 +0100
> > Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > 
> > > On Sun, 22 Jun 2008 19:54:46 +0200 (CEST)
> > > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > 
> > > > This message has been generated automatically as a part of a
> > > > report of recent regressions.
> > > > 
> > > > The following bug entry is on the current list of known
> > > > regressions from 2.6.25.  Please verify if it still should be
> > > > listed.
> > > > 
> > > > 
> > > > Bug-Entry	:
> > > > http://bugzilla.kernel.org/show_bug.cgi?id=10868
> > > > Subject		: Oops on loading ipaq module since
> > > > 2.6.26, prevents use of device Submitter	: Adam Williamson
> > > > <awilliamson@mandriva.com> Date		: 2008-06-05 17:39
> > > > (18 days old) Handled-By	: Alan Cox <alan@redhat.com>
> > > 
> > > Handed over to Greg as it's not a tty layer bug but something in USB
> > > (actually from the traces I think its a broken gcc/build but we
> > > shall)
> > 
> > http://www.kerneloops.org/search.php?search=ipaq_open
> > 
> > has a whole slew of different ones.... surprisingly they're almost all
> > with pppd...
> 
> btw this also shows that this isn't a 2.6.25 regression... 

That hardly shows it.

And Adam said quite explicitely that 2.6.25 worked for him.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

