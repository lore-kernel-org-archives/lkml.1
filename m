Return-Path: <linux-kernel-owner+w=401wt.eu-S1757932AbYGQMnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932AbYGQMnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 08:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbYGQMnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 08:43:39 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:38463 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbYGQMni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 08:43:38 -0400
Date: Thu, 17 Jul 2008 06:43:22 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Vrabel <david.vrabel@csr.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PCI: MSI interrupts masked using prohibited method
Message-ID: <20080717124322.GQ25255@parisc-linux.org>
References: <4860D09D.4060801@csr.com> <4864DA54.6000205@csr.com> <200806271007.26248.jbarnes@virtuousgeek.org> <200807161243.03360.jbarnes@virtuousgeek.org> <20080716195853.GL25255@parisc-linux.org> <m3wsjkemf0.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3wsjkemf0.fsf@maximus.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 02:16:03PM +0200, Krzysztof Halasa wrote:
> Remember that MSI predates INTX disable bit.

That's true.  MSI was introduced in PCI 2.2 and INTX disable was
introduced in PCI 2.3; a 3-year window.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
