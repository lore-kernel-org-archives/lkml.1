Return-Path: <linux-kernel-owner+w=401wt.eu-S1757045AbXEIOXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045AbXEIOXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 10:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbXEIOXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 10:23:31 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:3685 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbXEIOXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 10:23:30 -0400
Date: Wed, 9 May 2007 15:23:22 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: Satyam Sharma <satyam.sharma@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Anton Vorontsov <cbou@mail.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 8/8] One Laptop Per Child power/battery driver
In-Reply-To: <1178646751.2824.48.camel@pmac.infradead.org>
Message-ID: <Pine.LNX.4.64N.0705091504360.15372@blysk.ds.pg.gda.pl>
References: <20070503213303.GH20067@zarina> <20070507140453.GD3868@ucw.cz> 
 <1178550653.11851.191.camel@pmac.infradead.org>  <20070507194949.GB3981@ucw.cz>
  <a781481a0705071304m7f6d1b7ewa179e291f52689a4@mail.gmail.com> 
 <Pine.LNX.4.64N.0705081831070.30981@blysk.ds.pg.gda.pl>
 <1178646751.2824.48.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, David Woodhouse wrote:

> It's not an issue which needs resolving. We can spell your name just
> fine; we just need Pavel to quit whining and join us in the 21st
> century.

 I am pretty darn sure my name can be spelled correctly, but can it be 
reasonably assured to be printed correctly on a reasonable subset of 
systems out there?  Considering Linux only -- does our text-mode VGA 
console driver make any effort to print an arbitrary UTF-8-encoded text 
correctly?  What does it do when it runs beyond the limit of 512 
characters?  And how about serial terminals?

 When such issues are resolved and a reasonable subset of people, say 80%, 
either have or can make -- without unnecessary hassle -- their systems 
working properly in this respect, I can start thinking about using the 
correct spelling of my name.

 Until then I would rather work on code, sorry.  And that is not going to 
be any code related to UTF-8 either, but I do encourage anybody who really 
cares about it to address any or all issues raised above. :-)

  Maciej
