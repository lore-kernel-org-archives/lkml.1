Return-Path: <linux-kernel-owner+w=401wt.eu-S1756737AbYFAAnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737AbYFAAnS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 20:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755144AbYFAAnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 20:43:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56460 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139AbYFAAnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 20:43:06 -0400
Date: Sat, 31 May 2008 17:23:22 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Mikael Pettersson" <mikpe@it.uu.se>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>
Subject: Re: [Bug #10822] sky2 oops in 2.6.26-rc3
Message-ID: <20080531172322.633ea573@infradead.org>
In-Reply-To: <18497.59633.817344.933052@harpo.it.uu.se>
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik>
	<UJSav77TyUB.A.WKD.vqZQIB@albercik>
	<18497.59633.817344.933052@harpo.it.uu.se>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jun 2008 02:10:25 +0200
Mikael Pettersson <mikpe@it.uu.se> wrote:

> On Sat, 31 May 2008 19:48:06 +0200 (CEST), Rafael J. Wysocki wrote:
> >This message has been generated automatically as a part of a report
> >of recent regressions.
> >
> >The following bug entry is on the current list of known regressions
> >from 2.6.25.  Please verify if it still should be listed.
> >
> >
> >Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D10822
> >Subject		: sky2 oops in 2.6.26-rc3
> >Submitter	: Mikael Pettersson <mikpe@it.uu.se>
> >Date		: 2008-05-25 17:27 (7 days old)
> >References	:
> >http://marc.info/?l=3Dlinux-netdev&amp;m=3D121173650915153&amp= ;w=3D4
> >Handled-By	: Stephen Hemminger
> ><shemminger@linux-foundation.org>
> 
> It's a one-off crash that hasn't happened since I reported it.
> And the fact that it happended while I was running 2.6.26-rc3
> may just be coincidental and/or caused by temperamental HW.
> 
> My intention was never to classify this as a regression, I
> just wanted to report a failure data point in case a pattern
> emerges.

http://www.kerneloops.org/search.php?search=sky2_mac_int

shows that it happened around 2.6.23-rc1 era once as well...
but not more than that.

That almost makes it look like a hw issue, and very unlikely as a
regression.
