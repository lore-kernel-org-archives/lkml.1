Return-Path: <linux-kernel-owner+w=401wt.eu-S1760236AbZBFRXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760236AbZBFRXx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 12:23:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbZBFRXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 12:23:42 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41064 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbZBFRXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 12:23:40 -0500
Date: Fri, 6 Feb 2009 17:22:07 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>, hskinnemoen@atmel.com,
       cooloney@kernel.org, tony.luck@intel.com, ralf@linux-mips.org,
       dhowells@redhat.com, matthew@wil.cx, chris@zankel.net,
       LKML <linux-kernel@vger.kernel.org>,
       linux-next <linux-next@vger.kernel.org>,
       linux-ia64 <linux-ia64@vger.kernel.org>
Subject: Re: [linux-next][PATCH] revert headers_check fix: ia64, fpu.h
Message-ID: <20090206172207.GL13758@n2100.arm.linux.org.uk>
References: <20090206145556.GH18368@elte.hu> <1233934141.3209.20.camel@localhost.localdomain> <20090206153315.GD13758@n2100.arm.linux.org.uk> <1233935328.3209.30.camel@localhost.localdomain> <20090206155512.GF13758@n2100.arm.linux.org.uk> <20090206161229.GA8256@elte.hu> <20090206162352.GI13758@n2100.arm.linux.org.uk> <20090206163314.GA11216@elte.hu> <20090206163857.GJ13758@n2100.arm.linux.org.uk> <20090206171400.GA14818@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090206171400.GA14818@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 06, 2009 at 06:14:00PM +0100, Ingo Molnar wrote:
> I take this that you kind of agree that that removing ugly #ifdefs spread 
> out is an upside. You failed to point out any downsides - you just seem to 
> claim that you can live without the upsides. That is fine.

I'm sorry, I thought I pointed them out in my previous emails.  Clearly
you didn't read those emails in spite of replying to them.
