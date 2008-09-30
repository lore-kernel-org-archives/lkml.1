Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbYI3B4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbYI3B4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 21:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbYI3B40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 21:56:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752401AbYI3B4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 21:56:25 -0400
Date: Mon, 29 Sep 2008 18:56:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com
Subject: Re: Linux 2.6.27-rc8
In-Reply-To: <Pine.LNX.4.64.0809300125460.2307@twin.jikos.cz>
Message-ID: <alpine.LFD.2.00.0809291855000.3389@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org> <Pine.LNX.4.64.0809300125460.2307@twin.jikos.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Sep 2008, Jiri Kosina wrote:
> 
> Intel is working with us on tracking down and resolving the issue, but 
> this is not going as well as one would like to see (one attempt, one card 
> with completely hosed EEPROM contents ... and restoring the contents is 
> not *that* trivial).

What's the magic to trigger it? I've got a laptop with that e1000e chip in 
it, and am obviously running a recent kernel on it. Do people have a 
handle on it? Is it actually verified to be kernel-related, and not 
related to the X server etc?

		Linus
