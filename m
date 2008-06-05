Return-Path: <linux-kernel-owner+w=401wt.eu-S1762996AbYFEUyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762996AbYFEUyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 16:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbYFEUxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 16:53:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56088 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761202AbYFEUxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 16:53:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Bug #10822] sky2 oops in 2.6.26-rc3
Date: Thu, 5 Jun 2008 22:54:34 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Mikael Pettersson <mikpe@it.uu.se>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik> <18497.59633.817344.933052@harpo.it.uu.se> <20080531172322.633ea573@infradead.org>
In-Reply-To: <20080531172322.633ea573@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806052254.34861.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 1 of June 2008, Arjan van de Ven wrote:
> On Sun, 1 Jun 2008 02:10:25 +0200
> Mikael Pettersson <mikpe@it.uu.se> wrote:
> 
> > On Sat, 31 May 2008 19:48:06 +0200 (CEST), Rafael J. Wysocki wrote:
> > >This message has been generated automatically as a part of a report
> > >of recent regressions.
> > >
> > >The following bug entry is on the current list of known regressions
> > >from 2.6.25.  Please verify if it still should be listed.
> > >
> > >
> > >Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10822
> > >Subject		: sky2 oops in 2.6.26-rc3
> > >Submitter	: Mikael Pettersson <mikpe@it.uu.se>
> > >Date		: 2008-05-25 17:27 (7 days old)
> > >References	:
> > >http://marc.info/?l=linux-netdev&amp;m=121173650915153&amp= ;w=4
> > >Handled-By	: Stephen Hemminger
> > ><shemminger@linux-foundation.org>
> > 
> > It's a one-off crash that hasn't happened since I reported it.
> > And the fact that it happended while I was running 2.6.26-rc3
> > may just be coincidental and/or caused by temperamental HW.
> > 
> > My intention was never to classify this as a regression, I
> > just wanted to report a failure data point in case a pattern
> > emerges.
> 
> http://www.kerneloops.org/search.php?search=sky2_mac_int
> 
> shows that it happened around 2.6.23-rc1 era once as well...
> but not more than that.
> 
> That almost makes it look like a hw issue, and very unlikely as a
> regression.

Dropped from the list of recent regressions.

Thanks,
Rafael
