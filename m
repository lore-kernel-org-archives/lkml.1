Return-Path: <linux-kernel-owner+w=401wt.eu-S1759831AbXHLHO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759831AbXHLHO5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 03:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941AbXHLHOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 03:14:48 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:45745 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbXHLHOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 03:14:47 -0400
Date: Sat, 11 Aug 2007 16:12:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Documentation files in html format?
Message-Id: <20070811161200.bf9b6259.randy.dunlap@oracle.com>
In-Reply-To: <20070810201704.GI6002@1wt.eu>
References: <20070809113122.3aa508e4@oldman.hamilton.local>
	<20070810201704.GI6002@1wt.eu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 22:17:04 +0200 Willy Tarreau wrote:

> Hi Stephen,
> 
> On Thu, Aug 09, 2007 at 11:31:22AM +0100, Stephen Hemminger wrote:
> > Since the network device documentation needs a rewrite, I was thinking
> > of using basic html format instead of just plain text. But since this would
> > be starting an new precedent for kernel documentation, some it seemed
> > like a worthwhile topic for discussion.
> 
> I've read pro-plain text arguments, so I'll not repeat them. I also see
> another advantage to plain text : it's very easy to draw ascii-art
> diagrams of anything. It only takes a few minutes, is always inline
> and readable with any tool. Look at the bonding doc I wrote and updated
> in 2000, people have updated or duplicated some of the diagrams when
> they have added features. Something they would definitely not have done
> if it had required some strange tool.
> 
> Also, the advantage of plain text is that it stays compatible with
> everything though the years. Had I used some random tool in 2000 for
> this, I'm not sure the tool would still exist right now. Look at RFCs.

This is getting dangerously close to an XML discussion.  ;)

ISTM (from reading the IETF mailing list) that the recommended tools
for generating plaintext RFCs are either
a) xml2rfc (from http://tools.ietf.org/inventory/author-tools)
or
b) an MS Word plugin/macro/whatever.

There is also an xml RFC to pdf/ps converter here:
http://www.arkko.com/tools/xml2pdfrfc.html


> Nothing fancy, just readable. Even the TCP FSM in rfc793 from 26 years
> ago is readable, understandable, and updatable by anybody (though it's
> a little mit messy). And it's somewhat an extreme case ;-)
> 
> I'd prefer that you define some writing conventions for plain-text
> documents that anyone should try follow, starting with the 80-cols
> limit to make Davem happy. I think that many of us can help define
> such a "standard" indicating how to underline subtitles, how to
> enumerate a list, how to avoid using tabs, how to write boxes and
> arrows in their diagrams, etc...

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
