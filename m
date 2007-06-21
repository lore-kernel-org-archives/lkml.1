Return-Path: <linux-kernel-owner+w=401wt.eu-S1757877AbXFUPHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877AbXFUPHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 11:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755578AbXFUPHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 11:07:40 -0400
Received: from gw.goop.org ([64.81.55.164]:60299 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755576AbXFUPHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 11:07:39 -0400
Message-ID: <467A93F3.3050407@goop.org>
Date: Thu, 21 Jun 2007 08:06:27 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: ian <spyro@f2s.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Arch <linux-arch@vger.kernel.org>,
       Richard Henderson <rth@twiddle.net>,
       Russell King <rmk@arm.linux.org.uk>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Aubrey Li <aubrey.li@analog.com>, Mikael Starvik <starvik@axis.com>,
       David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>, Andi Kleen <ak@suse.de>,
       Tony Luck <tony.luck@intel.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Ralf Baechle <ralf@linux-mips.org>, Matthew Wilcox <matthew@wil.cx>,
       Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>,
       Miles Bader <uclinux-v850@lsi.nec.co.jp>,
       Chris Zankel <chris@zankel.net>
Subject: Re: [PATCH] cross-architecture ELF clean up
References: <20070620230854.246399397@goop.org>	 <20070620230902.387008536@goop.org> <1182414053.2942.0.camel@wirenth>
In-Reply-To: <1182414053.2942.0.camel@wirenth>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ian wrote:
> On Wed, 2007-06-20 at 16:08 -0700, Jeremy Fitzhardinge wrote:
>
> arm26 changes acked-by: Ian Molton <spyro@f2s.com>

Did you try building it to flush out any missing-header problems?

    J
