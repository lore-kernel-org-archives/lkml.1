Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbXHKFma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbXHKFma (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 01:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbXHKFmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 01:42:22 -0400
Received: from 1wt.eu ([62.212.114.60]:1310 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbXHKFmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 01:42:21 -0400
Date: Sat, 11 Aug 2007 07:33:47 +0200
From: Willy Tarreau <w@1wt.eu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Documentation files in html format?
Message-ID: <20070811053347.GC24082@1wt.eu>
References: <20070809113122.3aa508e4@oldman.hamilton.local> <20070810201704.GI6002@1wt.eu> <20070810204025.GC29549@fieldses.org> <20070810205117.GJ6002@1wt.eu> <20070810230830.GA5922@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070810230830.GA5922@uranus.ravnborg.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 11, 2007 at 01:08:30AM +0200, Sam Ravnborg wrote:
> > 
> > The problem I have with asciidoc is that it's a nightmare to get it
> > to work. It's what GIT uses, and after spending a whole day trying
> > to *build* that thing, I finally resigned and asked Junio if he could
> > publish the pre-formatted manpages himself, which he agreed to.
> 
> Bit uses in addition to asciidoc also docbook and a bit more.
> As asciidoc is some phython scripts it should be trivial to
> install with no build required.

I remember it relied on some tools to process xml, but I don't know
exactly what. It were those tools which I could not build.

> Maybe it was the docbook stuff you had trouble with?

possible, I don't remember that much, it was a painful day one year ago.

> My Kbuild example were made without using other tools than asciidoc but
> if pdf is desired some additional tools are needed.

It was just needed to build the man pages, so I would have expected it
to be pretty straight-forward too.

Willy

