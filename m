Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbYAVWsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbYAVWsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 17:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbYAVWso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 17:48:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60391 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbYAVWsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 17:48:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.24-rc8-git5: Reported regressions from 2.6.23
Date: Tue, 22 Jan 2008 23:46:12 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>
References: <200801222309.55876.rjw@sisk.pl> <20080122223611.72acc51f@lxorguk.ukuu.org.uk>
In-Reply-To: <20080122223611.72acc51f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801222346.13023.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 22 of January 2008, Alan Cox wrote:
> 
> > Subject		: PATA_HPT37X embezzles two ports
> > Submitter	: "Bjoern Olausson" <lkmlist@gmail.com>
> > Date		: 2007-12-12 11:05
> > References	: http://lkml.org/lkml/2007/12/12/161
> > 		  http://bugzilla.kernel.org/show_bug.cgi?id=9551
> > Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>
> > Patch		: http://lkml.org/lkml/2007/1/4/161
> 
> This has been present in the kernel fixed for some time.

I'll remove it from the list.  Which commit has fixed it, btw?
