Return-Path: <linux-kernel-owner+w=401wt.eu-S1752989AbXD1Xio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbXD1Xio (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 19:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754399AbXD1Xio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 19:38:44 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:47775 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbXD1Xin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 19:38:43 -0400
X-Originating-Ip: 74.109.98.66
Date: Sat, 28 Apr 2007 19:38:33 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: random thoughts on DEPRECATED and OBSOLETE
In-Reply-To: <4633CA7F.6010505@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0704281933160.29552@localhost.localdomain>
References: <Pine.LNX.4.64.0704280925270.24691@localhost.localdomain>
 <46337BD2.7000701@s5r6.in-berlin.de> <Pine.LNX.4.64.0704281320560.27098@localhost.localdomain>
 <4633ACE4.50004@s5r6.in-berlin.de> <Pine.LNX.4.64.0704281635190.28274@localhost.localdomain>
 <4633CA7F.6010505@s5r6.in-berlin.de>
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

> I see a discussion on OBSOLETE vs. BROKEN there, which even ended in
> a consensus, but I do not see an explicit discussion on OBSOLETE vs.
> DEPRECATED.

i think this online definition matches what i have in mind:

http://www.google.com/search?hl=en&rls=GGGL,GGGL:2006-10,GGGL:en&defl=en&q=define:Deprecated&sa=X&oi=glossary_definition&ct=title

"A deprecated element or attribute is one that has been outdated by
newer constructs. Deprecated elements are defined in the reference
manual in appropriate locations, but are clearly marked as deprecated.
Deprecated elements may become obsolete in future versions of HTML. We
recommend that authors avoid using deprecated elements and attributes
whenever practical."

  note carefully how deprecated elements can still be used, but their
use is discouraged and they *may become obsolete*.  that's exactly
what i was getting at.  deprecated stuff *might* still be used;
obsolete stuff *shouldn't* be used.

rday

p.s.  just FYI, even *i'm* getting bored of this.  :-)
