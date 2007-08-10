Return-Path: <linux-kernel-owner+w=401wt.eu-S941521AbXHJUkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941521AbXHJUkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 16:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933655AbXHJUka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 16:40:30 -0400
Received: from mail.fieldses.org ([66.93.2.214]:38808 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765956AbXHJUk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 16:40:29 -0400
Date: Fri, 10 Aug 2007 16:40:25 -0400
To: Willy Tarreau <w@1wt.eu>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Documentation files in html format?
Message-ID: <20070810204025.GC29549@fieldses.org>
References: <20070809113122.3aa508e4@oldman.hamilton.local> <20070810201704.GI6002@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070810201704.GI6002@1wt.eu>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 10:17:04PM +0200, Willy Tarreau wrote:
> I've read pro-plain text arguments, so I'll not repeat them. I also see
> another advantage to plain text : it's very easy to draw ascii-art
> diagrams of anything. It only takes a few minutes, is always inline
> and readable with any tool.

Asciidoc should preserve ascii-art diagrams OK; the git docs use them
all over.

Not that I'd necessarily push asciidoc.  But:

> I'd prefer that you define some writing conventions for plain-text
> documents that anyone should try follow, starting with the 80-cols
> limit to make Davem happy. I think that many of us can help define
> such a "standard" indicating how to underline subtitles, how to
> enumerate a list, how to avoid using tabs, how to write boxes and
> arrows in their diagrams, etc...

... at the point where you actually start setting standards for subtitle
underlining and list enumeration, you'd want to take another look at
asciidoc; since it already defines conventions for that stuff (which
are probably close to what people would do anyway), it might make sense
just to start using asciidoc.

--b.
