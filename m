Return-Path: <linux-kernel-owner+w=401wt.eu-S967027AbXFHB4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967027AbXFHB4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 21:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763802AbXFHB4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 21:56:15 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:65375 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbXFHB4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 21:56:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18024.46902.682920.924521@stoffel.org>
Date: Thu, 7 Jun 2007 21:56:06 -0400
From: "John Stoffel" <john@stoffel.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: John Stoffel <john@stoffel.org>, Krzysztof Halasa <khc@pm.waw.pl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel-rng: Undo mess made by an 80 column extremist
In-Reply-To: <20070608014719.GC23290@havoc.gtf.org>
References: <20070607162251.5f291325@the-village.bc.nu>
	<m3wsyfzcpt.fsf@maximus.localdomain>
	<18024.46233.432086.424311@stoffel.org>
	<20070608014719.GC23290@havoc.gtf.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Jeff> On Thu, Jun 07, 2007 at 09:44:57PM -0400, John Stoffel wrote:
>> I don't.  I use a pair of 80x48 xterms or emacs windows side by side
>> on my monitor with a nice big clear easy to read font.  Itty bitty

Jeff> That's pretty much what I do.  For me at least, it's a more
Jeff> efficient use of screen real estate, and of course the
Jeff> overwhelming majority of source code looks great in an 80-column
Jeff> text window.

Thinking about it more, I wonder if Krysztof is bitching more about
the tab width of 8 characters?   I know that it ticks me off,
indenting by two spaces is plenty for me to follow the flow, along
with Emacs and braces closure indication.  

I'm constantly un-tabifying code and making my indents be just two
spaces, though I guess I should really just change my tab-width to be
2 consistently.

What do you think Krysztof?

John
