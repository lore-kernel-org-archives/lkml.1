Return-Path: <linux-kernel-owner+w=401wt.eu-S1756697AbZD2MBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbZD2MBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 08:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755567AbZD2MBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 08:01:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:58547 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755363AbZD2MBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 08:01:13 -0400
Date: Wed, 29 Apr 2009 14:01:12 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: how to properly post/disseminate kernel cleanup/janitorial
 possibilities?
In-Reply-To: <alpine.LFD.2.00.0904280619590.16989@localhost.localdomain>
Message-ID: <alpine.LNX.2.00.0904291400200.5012@wotan.suse.de>
References: <alpine.LFD.2.00.0904271637470.4906@localhost.localdomain> <20090427222035.GA2700@cmpxchg.org> <alpine.LNX.2.00.0904281024150.5012@wotan.suse.de> <alpine.LFD.2.00.0904280619590.16989@localhost.localdomain>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009, Robert P. J. Day wrote:

> > > Perhaps Jiri can pick up some of the patches that remove stale 
> > > config symbols, correct typos etc.
> > Absolutely. I'll happily apply anything trivial enough (typo fixes,
> > removal of obviously unused symbols/config options, etc).
>   the *problem* is that, sometimes, it's not obvious.  as in, when a
> Kconfig file has a pile of unused config options but it turns out that
> those were added for future consideration to match up with code that
> hasn't been added yet and the subsystem maintainer knows about it but
> wants it to stay (IMHO, a really bad idea -- adding kernel features in
> incomplete pieces, but whatever).

Hmm ... do you have any particular outstanding examples of this?

-- 
Jiri Kosina
SUSE Labs
