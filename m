Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbYGDMZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbYGDMZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 08:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbYGDMZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 08:25:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35973 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753178AbYGDMZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 08:25:20 -0400
Date: Fri, 4 Jul 2008 13:07:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= <Uwe.Kleine-Koenig@digi.com>
Cc: Paul Mundt <lethal@linux-sh.org>, Oliver Neukum <oliver@neukum.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: alphabetic ordering of MAINTAINERS
Message-ID: <20080704130737.525507a5@lxorguk.ukuu.org.uk>
In-Reply-To: <20080704091023.GA9783@digi.com>
References: <20080704063455.GA13999@digi.com>
	<200807040852.27809.oliver@neukum.org>
	<20080704065722.GA22420@digi.com>
	<20080704085910.GA9671@linux-sh.org>
	<20080704091023.GA9783@digi.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > I always interpreted this to mean that the _entries_ are alphabetically
> > sorted, not the maintainers under each entry. IIRC, Alan has already
> > cleaned up most of the ordering of the entries through recent patches.
> That's how I interpret it, too. :-)
> 
> Look at
> 
> 	http://www.modarm9.com/git/people/ukleinek/linux-2.6.git?a=commitdiff;h=62110fbc73a9d3a4c7d39706b648b554b517f154#patch1


Nice but you've chopped off the Linus entry at the end. It would be good
to get the others fixed and the script in the scripts dir

BTW - I suspect your script needs to force a locale.

Alan
