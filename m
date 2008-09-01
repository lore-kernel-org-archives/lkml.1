Return-Path: <linux-kernel-owner+w=401wt.eu-S1752248AbYIAEBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbYIAEBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 00:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750748AbYIAEBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 00:01:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:55054 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbYIAEBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 00:01:36 -0400
Date: Sun, 31 Aug 2008 21:01:15 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #11438] Upcoming oops in lockdep
Message-ID: <20080831210115.4fdff99f@infradead.org>
In-Reply-To: <1220132205.8426.40.camel@twins>
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
	<N8SeMoDzuxC.A.C9D.FibuIB@albercik>
	<1220132205.8426.40.camel@twins>
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

On Sat, 30 Aug 2008 23:36:45 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Sat, 2008-08-30 at 21:50 +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11438
> > Subject		: Upcoming oops in lockdep
> > Submitter	: Arjan van de Ven <arjan@infradead.org>
> > Date		: 2008-08-23 20:49 (8 days old)
> > References	:
> > http://marc.info/?l=linux-kernel&m=121952463613140&w=4
> > http://www.kerneloops.org/searchweek.php?search=mark_lock
> > Handled-By	: Peter Zijlstra <peterz@infradead.org>
> 
> as far as I'm concerned this has nothing to do with lockdep
> 
>

yeah the pattern increasing looks like a fedora special; eg the fedora
utrace patches seem to be utter bust. As long as we keep utrace out of
mainline we're fine ;-)
