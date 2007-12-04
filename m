Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbXLDOyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbXLDOyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 09:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbXLDOy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 09:54:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40439 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbXLDOy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 09:54:28 -0500
Date: Tue, 4 Dec 2007 06:52:32 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Pavol Cvengros <pavol.cvengros@primeinteractive.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ICH9 & Core2 Duo - kernel crash
Message-ID: <20071204065232.2376f90b@laptopd505.fenrus.org>
In-Reply-To: <200712041331.24678.pavol.cvengros@primeinteractive.net>
References: <200712041331.24678.pavol.cvengros@primeinteractive.net>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2007 13:31:24 +0100
Pavol Cvengros <pavol.cvengros@primeinteractive.net> wrote:

> Hello,
> 
> I am trying LKML to get some help on one linux kernel related problem.
> Lately we got a machine with new HW from Intel. CPU is Intel Core2
> Duo E6850 3GHz with 2GB of RAM. Motherboard is Intel DG33BU with G33
> chipset.
> 
> After long fight with kernel crashes on different things, we figured
> out that if the multicore is disabled in bios, everything is ok and
> machine is running good. No kernel crashes no problems, but with one
> core only.
> 

to be honest, this looks like a thermal issue
are all your fans running?
is there anything in the case blocking air flow?


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
