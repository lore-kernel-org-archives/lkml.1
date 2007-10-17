Return-Path: <linux-kernel-owner+w=401wt.eu-S936538AbXJQCrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936538AbXJQCrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 22:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765953AbXJQCr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 22:47:28 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35682 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756398AbXJQCr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 22:47:27 -0400
Date: Tue, 16 Oct 2007 19:46:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Qi Yong <qiiyoong@gmail.com>
cc: Stefan Seyfried <seife@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Alexey Starikovskiy <alexey_y_starikovskiy@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH] swsusp: Use platform mode by default
In-Reply-To: <2cd57c900710161935l2121bffex78475ca33f0574ca@mail.gmail.com>
Message-ID: <alpine.LFD.0.999.0710161943440.26902@woody.linux-foundation.org>
References: <200611011323.14830.rjw@sisk.pl> <200705111121.51704.rjw@sisk.pl>
  <alpine.LFD.0.98.0705110912290.3986@woody.linux-foundation.org> 
 <200705112208.53971.rjw@sisk.pl>  <alpine.LFD.0.98.0705111550540.3986@woody.linux-foundation.org>
  <20070514075045.GA10238@suse.de>
 <2cd57c900710161935l2121bffex78475ca33f0574ca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Oct 2007, Qi Yong wrote:
> 
> The key point is "fall back to shutdown _only_ if !ops, otherwise
> don't touch hibernation_mode". And that solves my problem.

Please, when resurrecting a five-month-old discussion, give more of the 
old context.

I don't know about anybody else, but I get enough email that "five months" 
might as well be "last century" when it comes to email discussions, and I 
have long since forgotten the details of whatever caused the issue to 
begin with ;)

			Linus
