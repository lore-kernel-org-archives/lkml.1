Return-Path: <linux-kernel-owner+w=401wt.eu-S1759377AbXEMR4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759377AbXEMR4o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 13:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757318AbXEMR4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 13:56:36 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:54246 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757694AbXEMR4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 13:56:35 -0400
X-Originating-Ip: 72.143.66.196
Date: Sun, 13 May 2007 13:56:00 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Bernd Eckenfels <ecki@lina.inka.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: undeprecate raw driver.
In-Reply-To: <E1HnHxK-0004CI-00@calista.eckenfels.net>
Message-ID: <Pine.LNX.4.64.0705131347450.1144@localhost.localdomain>
References: <E1HnHxK-0004CI-00@calista.eckenfels.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2007, Bernd Eckenfels wrote:

> In article <Pine.LNX.4.64.0705131239200.942@localhost.localdomain> you wrote:
> > in short, do *not* remove its "deprecated" status.  rather, remove its
> > "obsolete" status and *make* it deprecated.
>
> it is deprecated and obsolete.

no, it's not.  and, trust me, no one on this list wants me to have to
explain all that again.  :-)

rday

p.s.  before we get into this again where everyone thinks they know
what they're talking about, i suggest consulting the official
definitions of those two terms as defined at
http://www.w3.org/TR/html4/conform.html:

Deprecated:
----------

"A deprecated element or attribute is one that has been outdated by
newer constructs. Deprecated elements are defined in the reference
manual in appropriate locations, but are clearly marked as deprecated.
Deprecated elements may become obsolete in future versions of HTML.

"User agents should continue to support deprecated elements for
reasons of backward compatibility.

"Definitions of elements and attributes clearly indicate which are
deprecated."

  got that?  deprecated means that it's been "outdated," but it's
still defined, it's still supported, it's marked as "deprecated", and
it ***may become*** obsolete in future versions.  if there's a better
description of raw drivers, i don't know where you'd find it.

Obsolete:
--------

"An obsolete element or attribute is one for which there is no
guarantee of support by a user agent."

  there.  see the difference?  why is this so difficult to grok?  you
can be deprecated, or you can be obsolete.  you *can't* be both.  so
please stop making that argument.

p.p.s.  using those definitions, deprecated features are *not*
possible candidates for removal, but obsolete features *are*.  that's
why raw drivers are deprecated, not obsolete.

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
