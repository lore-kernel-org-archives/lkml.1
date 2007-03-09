Return-Path: <linux-kernel-owner+w=401wt.eu-S1767174AbXCIL0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767174AbXCIL0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 06:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767199AbXCIL0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 06:26:24 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:44991 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767174AbXCIL0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 06:26:23 -0500
X-Originating-Ip: 74.109.98.130
Date: Fri, 9 Mar 2007 06:22:37 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: any thoughts yet on a "generic" ioctl.h?
In-Reply-To: <45F14232.5060703@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0703090617050.880@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0703081556260.9349@CPE00045a9c397f-CM001225dbafb6>
 <45F0D798.4050602@s5r6.in-berlin.de> <Pine.LNX.4.64.0703090450160.30726@CPE00045a9c397f-CM001225dbafb6>
 <45F14232.5060703@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2007, Stefan Richter wrote:

> Robert P. J. Day wrote:
> > each simplification could be submitted as
> > a separate arch-specific patch, as many things are.
> >
> > i was more asking about the *philosophy* of that patch,
>
> The justification of this initial patch is more obvious if followed
> up by those subsequent patches which make use of the initial one.

  no, it's not.  i should be able to ask about the *feasibility* of a
possible simplifying patch without having to provide an actual example
of its application. if someone can't immediately see what i'm trying
to do given the previously-posted patch, then they shouldn't be
commenting on it one way or the other.

  i'm not going to go to the trouble of creating and submitting all
possible follow-up patches, only to have someone higher up the food
chain "NAK" the whole idea on philosophical grounds.  either you can
see what i'm talking about or you can't.

rday

p.s.  there is already ample predecent for what i'm asking here.  one
can submit a patch to add, say, a simplifying macro to kernel.h
without simultaneously submitting patches for everywhere it possibly
might be used.

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
