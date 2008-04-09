Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbYDIRTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbYDIRTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 13:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbYDIRTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 13:19:12 -0400
Received: from barikada.upol.cz ([158.194.242.200]:45909 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbYDIRTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 13:19:11 -0400
Date: Wed, 9 Apr 2008 19:39:11 +0200
To: Bernd Petrovitsch <bernd@firmix.at>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kbuild devel list <linux-kbuild@vger.kernel.org>
Subject: Re: coloring stdout && stderr, small kbuild example
Message-ID: <20080409173911.GH24008@flower.upol.cz>
References: <E1Jjbol-0002zS-4P@flower> <1207754040.6860.7.camel@tara.firmix.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207754040.6860.7.camel@tara.firmix.at>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Time flies...

> > My last rant about "colored printk()" led away from kernel developers
> > and their solutions. But now, let me share something.

That was about "The True Kernel Developer's Way to Coloring"
by Jonathan Corbet October 9, 2007 http://lwn.net/Articles/253726/

Bernd Petrovitsch @ Wed, Apr 09, 2008 at 05:14:00PM +0200:

> I don't know if it's of any use for you but there is already
> *) color-make - http://bre.klaki.net/programs/colormake/ - and
> *) color-gcc - http://schlueters.de/colorgcc.html -
> out there.

Please, show those to http://udrepper.livejournal.com/17109.html
`perl` is more welcome in Debian, btw.

Free versions of color_proc_cpuinfo && color_meminfo:

TERMINAL_OUTPUT='s-"$1"-"$V$2m&$V${3-'$D'}m"-$4'

`color '[^:]*' 4 3`
`color :       3 2`
`color AMD     6 2`
`color Intel   6 2`
`color Athlon  '6;44' 2`
`color Pentium '6;44' 2`

Invent Your Own Easily(R)
--
sed 'sed && sh + olecom = love' << ''
-o--=O`C
 #oo'L O
<___=E M
