Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbYL2IBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbYL2IBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 03:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbYL2IBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 03:01:03 -0500
Received: from casper.infradead.org ([85.118.1.10]:59196 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbYL2IBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 03:01:01 -0500
Subject: Re: [PATCH] move arch/x86/pci/pci.h to
	arch/x86/include/asm/pci_x86.h
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, mj@ucw.cz
In-Reply-To: <20081229065713.GA10960@x200.localdomain>
References: <1230382948.3373.1.camel@jaswinder.satnam>
	 <20081229065713.GA10960@x200.localdomain>
Content-Type: text/plain; charset=utf8
Date: Mon, 29 Dec 2008 13:28:58 +0530
Message-Id: <1230537538.3090.4.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-29 at 09:57 +0300, Alexey Dobriyan wrote:
> On Sat, Dec 27, 2008 at 06:32:28PM +0530, Jaswinder Singh Rajput wrote:
> > Impact: cleanup, arch/x86/pci/pci.h -> arch/x86/include/asm/pci_x86.h
> 
> And this is done for what?

Don't you think ﻿arch/x86/pci/pci.h looks ugly it should be in
arch/x86/incluse/asm directory ?

It was suggested by Ingo :
http://marc.info/?l=linux-kernel&m=123037395221921&w=2

I think Ingo will have more valid reasons to satisfy your curiousity ;-)

Thank you,

JSR



