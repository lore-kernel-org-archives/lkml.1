Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbYIARHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbYIARHB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 13:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbYIARGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 13:06:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:41555 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbYIARGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 13:06:52 -0400
Date: Mon, 1 Sep 2008 10:06:49 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Jaswinder Singh" <jaswinderlinux@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Francois Romieu" <romieu@fr.zoreil.com>
Subject: Re: [Bug #11271] BUG: fealnx in 2.6.27-rc1
Message-ID: <20080901100649.59c1ab1f@infradead.org>
In-Reply-To: <3f9a31f40809011002k572450ffg90654912f3e1fa2a@mail.gmail.com>
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
	<N8SeMoDzuxC.A.xIG.OkbuIB@albercik>
	<3f9a31f40809011002k572450ffg90654912f3e1fa2a@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2008 13:02:29 -0400
"Jaswinder Singh" <jaswinderlinux@gmail.com> wrote:

> Hello all,
> 
> On Sat, Aug 30, 2008 at 3:50 PM, Rafael J. Wysocki <rjw@sisk.pl>
> wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me
> > know (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=11271
> > Subject         : BUG: fealnx in 2.6.27-rc1
> > Submitter       : Jaswinder Singh <jaswinderlinux@gmail.com>
> > Date            : 2008-08-05 14:58 (26 days old)
> > References      :
> > http://marc.info/?l=linux-netdev&m=121794762016830&w=4
> > http://lkml.org/lkml/2008/8/10/98 Handled-By      : Francois Romieu
> > <romieu@fr.zoreil.com>
> >
> >
> >
> 
> Still exists in 2.6.27-rc5 :
> 
> NETDEV WATCHDOG: eth0 (fealnx): transmit timed out


did you ever get transmit timeouts before 2.6.27 ?
(I would suspect you did)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
