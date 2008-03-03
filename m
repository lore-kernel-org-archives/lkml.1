Return-Path: <linux-kernel-owner+w=401wt.eu-S1752408AbYCCLnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbYCCLnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 06:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750908AbYCCLnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 06:43:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43534 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbYCCLnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 06:43:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc3-git3: Reported regressions from 2.6.24
Date: Mon, 3 Mar 2008 12:41:59 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>
References: <200803030316.07165.rjw@sisk.pl> <20080303075356.GB11526@elte.hu>
In-Reply-To: <20080303075356.GB11526@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803031242.00652.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 3 of March 2008, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > Unresolved regressions
> > ----------------------
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9938
> > Subject		: building fails on lguest
> > Submitter	: Cedric OLLIVIER <ollivier.cedric@gmail.com>
> > Date		: 2008-02-11 15:34
> 
> this should be resolved by:
> 
>  commit db342d216ba9e060d8c5501eefc1d0a789c9e711
>  Author: Tony Breeds <tony@bakeyournoodle.com>
>  Date:   Tue Feb 19 08:16:03 2008 +0100
> 
>      lguest: fix build breakage

Thanks, closed.

Rafael
