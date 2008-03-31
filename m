Return-Path: <linux-kernel-owner+w=401wt.eu-S1756453AbYCaIsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453AbYCaIsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 04:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbYCaIsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 04:48:46 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:35362 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752904AbYCaIsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 04:48:45 -0400
Message-ID: <47F0A575.3040605@davidnewall.com>
Date: Mon, 31 Mar 2008 19:18:53 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Peter Teoh <htmldeveloper@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>
Subject: Re: RFC:   Writing Solaris Device Drivers in Java
References: <47F0491F.4050804@gmail.com> <20080331055618.GC23796@1wt.eu>
In-Reply-To: <20080331055618.GC23796@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> On Mon, Mar 31, 2008 at 10:14:55AM +0800, Peter Teoh wrote:
>   
[snip]
>> imagine using a drivers written [in java] for 
>> the Solaris in Linux, won't it be cool?
>>     
> [...]
>
> So please keep these technologies for sucking your nearby powerplant's
> power and justifying your boss that you need a monster machine which
> would make HPC people jealous, but I would hate it to make it easier
> for the people I described above to pollute the kernel with their crap.

Perhaps somebody will argue that Java runs on quite small, even
low-power. machines; but all of that would still miss the point, I
think, that it's the differences between operating systems which prevent
drivers written for one platform from "just working" on another.  Look
at the effort that NDISwrapper has to go through to make a mere subset
of Windows drivers work on Linux: It wouldn't be any easier if those
drivers were written in Java.  Platforms are different and drivers
reflect those differences and that's the way it is.

And it's *still* not April 1.  This thread would have been quite clever
if it were.
