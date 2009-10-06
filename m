Return-Path: <linux-kernel-owner+w=401wt.eu-S933232AbZJFVVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933232AbZJFVVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 17:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933172AbZJFVVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 17:21:39 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33614 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933167AbZJFVVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 17:21:39 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4ACBB446.2010402@s5r6.in-berlin.de>
Date: Tue, 06 Oct 2009 23:19:02 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090926 SeaMonkey/1.1.17
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc3
References: <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <20091006153632.GA29795@elte.hu> <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain> <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain> <20091006164028.GA23305@elte.hu> <20091006181218.GD24677@mit.edu> <20091006182448.GB25732@elte.hu>
In-Reply-To: <20091006182448.GB25732@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
[...]
>  Linux europe 2.6.31+ #2 SMP Tue Oct 6 19:26:58 CEST 2009 i686 i686 i386 GNU/Linux
> 
> versus the inaccurate:
> 
>  Linux europe 2.6.31 #2 SMP Tue Oct 6 19:26:58 CEST 2009 i686 i686 i386 GNU/Linux
> 
> string which we emit today.

It's not the string which is inaccurate.  To assume that the version
string which is embedded into the kernel image fully describes the
kernel is inaccurate. :-)  The + suffix is an improvement in the sense
that it asserts that this kernel is not of a specific version...
-- 
Stefan Richter
-=====-==--= =-=- --==-
http://arcgraph.de/sr/
