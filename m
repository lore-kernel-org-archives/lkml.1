Return-Path: <linux-kernel-owner+w=401wt.eu-S1765626AbXHJXH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765626AbXHJXH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 19:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbXHJXHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 19:07:14 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:52665 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754182AbXHJXHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 19:07:13 -0400
Date: Sat, 11 Aug 2007 01:08:30 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Willy Tarreau <w@1wt.eu>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Documentation files in html format?
Message-ID: <20070810230830.GA5922@uranus.ravnborg.org>
References: <20070809113122.3aa508e4@oldman.hamilton.local> <20070810201704.GI6002@1wt.eu> <20070810204025.GC29549@fieldses.org> <20070810205117.GJ6002@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070810205117.GJ6002@1wt.eu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> The problem I have with asciidoc is that it's a nightmare to get it
> to work. It's what GIT uses, and after spending a whole day trying
> to *build* that thing, I finally resigned and asked Junio if he could
> publish the pre-formatted manpages himself, which he agreed to.

Bit uses in addition to asciidoc also docbook and a bit more.
As asciidoc is some phython scripts it should be trivial to
install with no build required.
Maybe it was the docbook stuff you had trouble with?

My Kbuild example were made without using other tools than asciidoc but
if pdf is desired some additional tools are needed.

	Sam
