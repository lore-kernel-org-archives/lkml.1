Return-Path: <linux-kernel-owner+w=401wt.eu-S1755096AbZD1IZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbZD1IZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 04:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754513AbZD1IZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 04:25:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60923 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223AbZD1IZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 04:25:19 -0400
Date: Tue, 28 Apr 2009 10:25:17 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: how to properly post/disseminate kernel cleanup/janitorial
 possibilities?
In-Reply-To: <20090427222035.GA2700@cmpxchg.org>
Message-ID: <alpine.LNX.2.00.0904281024150.5012@wotan.suse.de>
References: <alpine.LFD.2.00.0904271637470.4906@localhost.localdomain> <20090427222035.GA2700@cmpxchg.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009, Johannes Weiner wrote:

> > long story short, i have a *pile* of scripts and sub-scripts i'm happy 
> > to run and post the results of since it takes practically zero time on 
> > my part, i'm just open to what folks think is the most productive way 
> > to do that, and also for any other scanning i can add since, by now, 
> > any other patterns to scan for would just represent adding a line or 
> > two to a script.
> >  thoughts?
> Yes.  I wonder why you take the time to generate the output and email
> it but then stop there instead of just sending patches?
>
> grep -A5 TRIVIAL MAINTAINERS
> 
> Perhaps Jiri can pick up some of the patches that remove stale config
> symbols, correct typos etc.

Absolutely. I'll happily apply anything trivial enough (typo fixes, 
removal of obviously unused symbols/config options, etc).

Thanks,

-- 
Jiri Kosina
SUSE Labs
