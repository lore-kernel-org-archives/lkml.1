Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbZALSFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbZALSFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 13:05:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbZALSEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 13:04:55 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46161 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752620AbZALSEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 13:04:54 -0500
Date: Mon, 12 Jan 2009 18:04:39 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rob Landley <rob@landley.net>
Cc: Paul Mundt <lethal@linux-sh.org>, "Mark A. Miller" <mark@mirell.org>,
       Bernd Petrovitsch <bernd@firmix.at>,
       Leon Woestenberg <leon.woestenberg@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Message-ID: <20090112180439.0938ab5a@lxorguk.ukuu.org.uk>
In-Reply-To: <200901121156.17377.rob@landley.net>
References: <200901020207.30359.rob@landley.net>
	<31014a580901120118u55256b51g448f22e9e0ef5d1f@mail.gmail.com>
	<20090112094121.GD28564@linux-sh.org>
	<200901121156.17377.rob@landley.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I didn't say it was incapable of being supported.  We're _capable_ of 
> reimplementing the entire kernel in perl 

Which perl. What minor release, what day of the week syntax.

Ask anyone in the distribution business about the joy of perl and you can
listen to the screams for hours.

Perl5 has no formal grammar and you cannot tell what perl of the week
does and perl of last week doesn't do.

That makes it a bad candidate for our toolchain dependencies.


Alan
--
   "I don't want world domination if it means I have to deal with more
	people like this" - Mike Wangsmo
