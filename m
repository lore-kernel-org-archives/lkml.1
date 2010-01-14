Return-Path: <linux-kernel-owner+w=401wt.eu-S1757483Ab0ANTNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab0ANTNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 14:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757448Ab0ANTNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 14:13:48 -0500
Received: from mail.perches.com ([173.55.12.10]:1215 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757431Ab0ANTNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 14:13:47 -0500
Subject: Re: [PATCH 01/24] MAINTAINERS: Document new "Q:" patchwork queue
 type
From: Joe Perches <joe@perches.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20100114190534.57eb7326@lxorguk.ukuu.org.uk>
References: <cover.1263452908.git.joe@perches.com>
	 <dad0b9fe4d42d6523c16edfc5275a01de1272fd4.1263452908.git.joe@perches.com>
	 <4B4F20B3.703@s5r6.in-berlin.de> <4B4F2402.9040008@s5r6.in-berlin.de>
	 <1263490722.1903.12.camel@Joe-Laptop.home>
	 <4B4F5CC8.7020107@s5r6.in-berlin.de>
	 <1263492789.1903.19.camel@Joe-Laptop.home>
	 <4B4F63C4.1040602@s5r6.in-berlin.de>
	 <1263494720.1903.21.camel@Joe-Laptop.home>
	 <20100114190534.57eb7326@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jan 2010 11:13:45 -0800
Message-ID: <1263496425.1903.27.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-14 at 19:05 +0000, Alan Cox wrote:
> > www.google.com gives an easy interface to search for links.
> > How about we remove all other links in kernel sources?
> 
> What happens when google is down, someone googlebombs the reference you
> want, or if you are in China and Google decide to pull out ?

Exactly my point.

Removing links is not a good idea.
Redundancy is not a bad idea.
Asking people to perform unnecessary searches
is not a good idea.

When Stefan proposed a good patch to HOWTO, he failed
to notice the section immediately above his modification
includes git tree links which are also duplicated in
MAINTAINERS.  The duplication is fairly cost-free.

cheers, Joe


