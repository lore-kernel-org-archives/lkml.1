Return-Path: <linux-kernel-owner+w=401wt.eu-S1762477AbYAKTMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762477AbYAKTMZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 14:12:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758019AbYAKTMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 14:12:18 -0500
Received: from web32615.mail.mud.yahoo.com ([68.142.207.242]:24478 "HELO
	web32615.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756698AbYAKTMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 14:12:17 -0500
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jan 2008 14:12:17 EST
X-YMail-OSG: Ehy3f.gVM1nXgGGqo3.r9zl7m5KZfUUXhPne9Kufm_3iSInH
X-Mailer: YahooMailRC/818.31 YahooMailWebService/0.7.160
Date: Fri, 11 Jan 2008 11:05:36 -0800 (PST)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: [PATCH 00/11] writeback bug fixes and simplifications
To: WU Fengguang <wfg@mail.ustc.edu.cn>, Hans-Peter Jansen <hpj@urpla.net>
Cc: Sascha Warner <prx@cinatas.ath.cx>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <134583.81015.qm@web32615.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----
> From: WU Fengguang <wfg@mail.ustc.edu.cn>
> To: Hans-Peter Jansen <hpj@urpla.net>
> Cc: Sascha Warner <prx@cinatas.ath.cx>; Andrew Morton <akpm@linux-foundation.org>; linux-kernel@vger.kernel.org; Peter Zijlstra <a.p.zijlstra@chello.nl>
> Sent: Wednesday, January 9, 2008 4:33:32 AM
> Subject: Re: [PATCH 00/11] writeback bug fixes and simplifications
> 
> On Sat, Dec 29, 2007 at 03:56:59PM +0100, Hans-Peter Jansen wrote:
> > Am Freitag, 28. Dezember 2007 schrieb Sascha Warner:
> > > Andrew Morton wrote:
> > > > On Thu, 27 Dec 2007 23:08:40 +0100 Sascha
> Warner
> 
  
> > wrote:
> > > >> Hi,
> > > >>
> > > >> I applied your patches to 2.6.24-rc6-mm1, but now I am
> faced
> 
 with one
> > > >> pdflush often using 100% CPU for a long time. There seem to
> be
> 
 some
> > > >> rare pauses from its 100% usage, however.
> > > >>
> > > >> On ~23 minutes uptime i have ~19 minutes pdflush runtime.
> > > >>
> > > >> This is on E6600, x86_64, 2 Gig RAM, SATA HDD, running on gentoo
> > > >> ~x64_64
> > > >>
> > > >> Let me know if you need more info.
> > > >
> > > > (some) cc's restored.  Please, always do reply-to-all.
> > >
> > > Hi Wu,
> > 
> > Sascha, if you want to address Fengguang by his first name, note
> that
> 
 
> > chinese and bavarians (and some others I forgot now, too)
> typically
> 
 use the 
> > order:
> >   
> >   lastname firstname 
> > 
> > when they spell their names. Another evidence is, that the name Wu
> is
> 
 a 
> > pretty common chinese family name.
> > 
> > Fengguang, if it's the other way around, correct me please (and
> I'm
> 
 going to 
> > wear a big brown paper bag for the rest of the day..). 
> 
> You are right. We normally do "Fengguang" or "Mr. Wu" :-)
> For LKML the first name is less ambiguous.
> 
> Thanks,
> Fengguang
> 

 Just cannot resist. Hans-Peter mentions Bavarian using Lastname-Givenname as well. This is only true in a folklore context (or when you are very deep in the countryside). Officially the bavarians use the usual German Given/Lastname. Although they will never admit to be Germans, of course :-)


Cheers
Martin

