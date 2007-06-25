Return-Path: <linux-kernel-owner+w=401wt.eu-S1755268AbXFYMoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbXFYMoL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 08:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbXFYMn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 08:43:58 -0400
Received: from gw.goop.org ([64.81.55.164]:60920 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbXFYMn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 08:43:56 -0400
Message-ID: <467FB856.2030200@goop.org>
Date: Mon, 25 Jun 2007 08:43:02 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Arch <linux-arch@vger.kernel.org>,
       Richard Henderson <rth@twiddle.net>, Ian Molton <spyro@f2s.com>,
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
References: <20070620230854.246399397@goop.org>	 <20070620230902.387008536@goop.org> <1182762166.12109.19.camel@pmac.infradead.org>
In-Reply-To: <1182762166.12109.19.camel@pmac.infradead.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Wed, 2007-06-20 at 16:08 -0700, Jeremy Fitzhardinge wrote:
>   
>> This patch cleans up the ELF headers and their users.  It does several
>> related things:
>>     
>
> Looks good. We can get away with exporting a lot less of this to
> userspace too, can't we?
>   

Probably.  What needs to be exported at all?

    J

