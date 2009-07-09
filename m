Return-Path: <linux-kernel-owner+w=401wt.eu-S1751648AbZGIW0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbZGIW0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 18:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750717AbZGIW0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 18:26:47 -0400
Received: from kroah.org ([198.145.64.141]:43274 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbZGIW0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 18:26:46 -0400
Date: Thu, 9 Jul 2009 15:26:26 -0700
From: Greg KH <greg@kroah.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       David Howells <dhowells@redhat.com>, benh@kernel.crashing.org,
       paulus@samba.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       jdike@addtoit.com, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Miller <davem@davemloft.net>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       dbrownell@users.sourceforge.net, mchehab@infradead.org,
       jeremy@xensource.com, felixb@sgi.com, lenb@kernel.org, airlied@linux.ie,
       bcrl@kvack.org, Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [GIT-PULL] includecheck fixes
Message-ID: <20090709222626.GA32746@kroah.com>
References: <1247063308.4382.12.camel@ht.satnam>
 <1247164809.2452.9.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247164809.2452.9.camel@ht.satnam>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 12:10:09AM +0530, Jaswinder Singh Rajput wrote:
> Linus,
> 
> Please pull includecheck fixes, these all are clean and safe patches
> with relevant Acks.

Shouldn't stuff like this go through the trivial tree?  And stuff like
that is relevant for the main pre-rc1 merge, not this late in the merge
cycle, right?

thanks,

greg k-h
