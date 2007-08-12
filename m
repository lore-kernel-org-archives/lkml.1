Return-Path: <linux-kernel-owner+w=401wt.eu-S937628AbXHLPmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937628AbXHLPmr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760061AbXHLPmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:42:38 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:42353 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766AbXHLPmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:42:37 -0400
Date: Sun, 12 Aug 2007 17:43:28 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Willy Tarreau <w@1wt.eu>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Documentation files in html format?
Message-ID: <20070812154328.GB13141@uranus.ravnborg.org>
References: <20070809113122.3aa508e4@oldman.hamilton.local> <20070810201704.GI6002@1wt.eu> <20070810204025.GC29549@fieldses.org> <20070810205117.GJ6002@1wt.eu> <20070811141925.GA21866@fieldses.org> <20070811141718.GK6002@1wt.eu> <20070811201210.f5ba7d4d.rdunlap@xenotime.net> <46BF06E1.9000302@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46BF06E1.9000302@s5r6.in-berlin.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 03:10:57PM +0200, Stefan Richter wrote:
> 
> One note on asciidoc:  I experienced the same as Willy when I wanted to
> build git with manpages on a distribution without prebuilt asciidoc.

I assume you had troubles with the docbook utilities and not asciidoc itself.
asciidoc is used to generate the format used by docbook utilities to
generate man-pages.

The html example I posted previously were made solely by asciidoc and no
additional docbook stuff.

	Sam
