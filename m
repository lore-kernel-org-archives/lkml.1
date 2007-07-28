Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbXG1Sby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbXG1Sby (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 14:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbXG1Sbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 14:31:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38315 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752378AbXG1Sbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 14:31:45 -0400
Date: Sat, 28 Jul 2007 11:31:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Len Brown <lenb@kernel.org>, david@lang.hm,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: CONFIG_SUSPEND? (was: Re: [GIT PATCH] ACPI patches for
 2.6.23-rc1)
In-Reply-To: <200707282029.03563.rjw@sisk.pl>
Message-ID: <alpine.LFD.0.999.0707281130110.3442@woody.linux-foundation.org>
References: <200707251238.50218.lenb@kernel.org>
 <alpine.LFD.0.999.0707280921150.3442@woody.linux-foundation.org>
 <alpine.LFD.0.999.0707280932470.3442@woody.linux-foundation.org>
 <200707282029.03563.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Jul 2007, Rafael J. Wysocki wrote:
> 
> OK, I'll prepare a patch to introduce CONFIG_SUSPEND, but that will require
> quite a bit of (compilation) testing on different architectures.

Sure. I'm not too worried, the fallout should be of the trivial kind. 

Also, mind basing it on the (independent) cleanups that Adrian already 
sent out. This is all intertwined..

		Linus
