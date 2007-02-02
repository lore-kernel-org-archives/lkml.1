Return-Path: <linux-kernel-owner+w=401wt.eu-S1423155AbXBBGsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423155AbXBBGsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 01:48:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423156AbXBBGsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 01:48:33 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:2129 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423155AbXBBGsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 01:48:33 -0500
Message-ID: <45C2DE8A.7040201@jonmasters.org>
Date: Fri, 02 Feb 2007 01:47:38 -0500
From: Jon Masters <jonathan@jonmasters.org>
Organization: World Organi[sz]ation Of Broken Dreams
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Chris Rankin <rankincj@yahoo.com>, Mark Rustad <mrustad@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.18-stable release plans?
References: <999038.34946.qm@web52908.mail.yahoo.com> <200702020402.l12427em008810@turing-police.cc.vt.edu>
In-Reply-To: <200702020402.l12427em008810@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:

> "With 100 million computers in use today, we should expect roughly 6 million
> single bit errors per year. Computer hardware and software companies must
> receive thousands of "side effect" bug reports and support calls due to memory
> errors alone. The costs of NOT including parity memory must be huge!"

I must be weird or something, but I often think about this and the sheer 
number of clock cycles executing at any one time around the world. Have 
you ever stopped to think how many copies of schedule() (or whatever) 
are currently running somewhere in the world? It's just nuts :-)

More seriously, if nobody cared about this stuff then we wouldn't have 
all this MCE reporting and tools to handle differentiating between 
actual failing DRAMs and temporary bit transitions in ECC memory.

Jon.
