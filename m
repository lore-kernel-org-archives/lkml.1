Return-Path: <linux-kernel-owner+w=401wt.eu-S1759468AbYIALou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468AbYIALou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 07:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbYIALom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 07:44:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36168 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538AbYIALol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 07:44:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Bug #11438] Upcoming oops in lockdep
Date: Mon, 1 Sep 2008 13:48:29 +0200
User-Agent: KMail/1.9.9
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik> <1220132205.8426.40.camel@twins> <20080831210115.4fdff99f@infradead.org>
In-Reply-To: <20080831210115.4fdff99f@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809011348.29917.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 1 of September 2008, Arjan van de Ven wrote:
> On Sat, 30 Aug 2008 23:36:45 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Sat, 2008-08-30 at 21:50 +0200, Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.26.  Please verify if it still should be listed and let me
> > > know (either way).
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11438
> > > Subject		: Upcoming oops in lockdep
> > > Submitter	: Arjan van de Ven <arjan@infradead.org>
> > > Date		: 2008-08-23 20:49 (8 days old)
> > > References	:
> > > http://marc.info/?l=linux-kernel&m=121952463613140&w=4
> > > http://www.kerneloops.org/searchweek.php?search=mark_lock
> > > Handled-By	: Peter Zijlstra <peterz@infradead.org>
> > 
> > as far as I'm concerned this has nothing to do with lockdep
> > 
> >
> 
> yeah the pattern increasing looks like a fedora special; eg the fedora
> utrace patches seem to be utter bust. As long as we keep utrace out of
> mainline we're fine ;-)

Should I close it, then?

Rafael
