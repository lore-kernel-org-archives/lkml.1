Return-Path: <linux-kernel-owner+w=401wt.eu-S1754979AbXD2Ge7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbXD2Ge7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 02:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754983AbXD2Ge7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 02:34:59 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:37471 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979AbXD2Geo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 02:34:44 -0400
X-Originating-Ip: 74.109.98.66
Date: Sun, 29 Apr 2007 02:34:31 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: random thoughts on DEPRECATED and OBSOLETE
In-Reply-To: <4633E55B.1080601@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0704290232050.3648@localhost.localdomain>
References: <Pine.LNX.4.64.0704280925270.24691@localhost.localdomain>
 <46337BD2.7000701@s5r6.in-berlin.de> <Pine.LNX.4.64.0704281320560.27098@localhost.localdomain>
 <4633ACE4.50004@s5r6.in-berlin.de> <Pine.LNX.4.64.0704281635190.28274@localhost.localdomain>
 <4633CA7F.6010505@s5r6.in-berlin.de> <Pine.LNX.4.64.0704281933160.29552@localhost.localdomain>
 <4633E55B.1080601@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Apr 2007, Stefan Richter wrote:

> Robert P. J. Day wrote:
> > i think this online definition matches what i have in mind:
> >
> > http://www.google.com/search?hl=en&rls=GGGL,GGGL:2006-10,GGGL:en&defl=en&q=define:Deprecated&sa=X&oi=glossary_definition&ct=title
>
> "Definitions of Deprecated on the Web: [...] This term is used to refer
> to /obsolete/ structures that should not be used for new applications".
>
> Emphasis is mine.
> I can agree with this and the other definitions at this search result.

you're conflating those two again.  here's my last attempt -- see the
definitions here:

http://www.w3.org/TR/html401/conform.html

and note the fundamental distinction:

deprecated:  "... User agents should continue to support deprecated
                                     ^^^^^^^^^^^^^^^^^^^
elements for reasons of backward compatibility..."

obsolete:  "... no guarantee of support by a user agent."
                ^^^^^^^^^^^^^^^^^^^^^^^
  that's it -- there's the fundamental difference.  i really don't
care if you can find other wordings that you can interpret
differently.  in *my* proposal, those two definitions are not
orthogonal, they are mutually exclusive.  period.  end of discussion.
if you can't accept that, feel free to submit your own proposal.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
