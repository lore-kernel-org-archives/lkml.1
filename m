Return-Path: <linux-kernel-owner+w=401wt.eu-S1752991AbXDIGLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbXDIGLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 02:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbXDIGLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 02:11:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:53833 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752988AbXDIGLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 02:11:17 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18fnStH/sofqV+iQyuaqbex91uxpUhNXBkn1X86sL
	L2eHV4nF8nugjw
Subject: Re: Ten percent test
From: Mike Galbraith <efault@gmx.de>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
In-Reply-To: <200704090123.08259.gene.heskett@gmail.com>
References: <200703290237.38777.kernel@kolivas.org>
	 <200704081357.43370.gene.heskett@gmail.com>
	 <1176092356.6355.18.camel@Homer.simpson.net>
	 <200704090123.08259.gene.heskett@gmail.com>
Content-Type: text/plain
Date: Mon, 09 Apr 2007 08:09:41 +0200
Message-Id: <1176098981.6355.118.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-09 at 01:23 -0400, Gene Heskett wrote:

> This may not be so informative, its almost behaving ATM.
> 
> 29252 amanda    22   0  1856  572  220 R 76.4  0.1   1:07.24 gzip
> 29235 amanda    15   0  2992 1224  888 S  5.6  0.1   0:02.80 chunker
> 29500 root      18   0  2996 1164  788 S  4.0  0.1   0:02.40 tar
> 10459 amanda    15   0  3340 1052  832 S  3.0  0.1   0:49.04 amandad
> 10536 amanda    15   0  3276 1308 1004 S  2.3  0.1   0:40.92 dumper
> 29496 amanda    18   0  2808  472  280 S  2.0  0.0   0:01.73 sendbackup
>  4057 gkrellmd  15   0 11568 1172  896 S  1.3  0.1   7:45.82 gkrellmd
> 29498 amanda    18   0  2396  780  656 S  1.0  0.1   0:00.60 tar
> 19183 root      15   0     0    0    0 S  0.7  0.0   0:01.92 pdflush
> 

Yeah, this is showing the scheduler behaving properly.

	-Mike

