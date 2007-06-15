Return-Path: <linux-kernel-owner+w=401wt.eu-S1756460AbXFOSCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbXFOSCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 14:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755785AbXFOSCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 14:02:39 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:28531 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725AbXFOSCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 14:02:37 -0400
Date: Fri, 15 Jun 2007 11:03:26 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Chris Friesen" <cfriesen@nortel.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       dave young <hidave.darkstar@gmail.com>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>, Willy Tarreau <w@1wt.eu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: coding style
Message-Id: <20070615110326.b0762b7a.randy.dunlap@oracle.com>
In-Reply-To: <4672D246.2040306@nortel.com>
References: <20070614184836.GA6520@cvg>
	<20070615045111.GU943@1wt.eu>
	<46721F18.8090303@intel.com>
	<a8e1da0706142338s6cd76e94hf7a4c44ed5b067a0@mail.gmail.com>
	<Pine.LNX.4.64.0706151109430.32724@fbirervta.pbzchgretzou.qr>
	<20070615173206.GA8151@cvg>
	<4672D246.2040306@nortel.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2007 11:54:14 -0600 Chris Friesen wrote:

> Cyrill Gorcunov wrote:
> 
> > Thanks to all of you for answering. Actually I was concerning about function
> > arguments' alignment (on separated lines) not about indentation. So as I see
> > it's a question of bent ;) And a simple rule exist - use tabs for indents
> > and spaces for alignment (when amount of spaces are < 8).
> 
> That rule doesn't actually work though, an is imposed by tools limitations.
> 
> Consider two people, one with tabs as 8 characters and one with tabs as 
> 4 characters.  If person A aligns using a tab plus a space (giving 9 
> characters), then the alignmnet will be all screwed up for person B (who 
> will see 5 characters of alignment).
> 
> The only rule that works (setting aside bad tools) is:
> 
> "use tabs for indents and spaces for alignment"
> 
> If that means you need to use two dozen spaces, then so be it.

I don't think that's what that rule means, but I didn't write it,
so I'm not absolutely sure about it.

but we know that tab stops are every 8th character, not 4 :)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
