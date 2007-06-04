Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbXFDMPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbXFDMPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 08:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbXFDMPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 08:15:07 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:44121 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbXFDMPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 08:15:05 -0400
Date: Mon, 4 Jun 2007 13:14:58 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Message-ID: <20070604121457.GA26615@srcf.ucam.org>
References: <8pwhX-46n-3@gated-at.bofh.it> <8pCQo-5QL-7@gated-at.bofh.it> <87abvogbdp.fsf@buer.dfakt.de> <200705281406.57396.david-b@pacbell.net> <20070531043229.GA30888@dose.home.local> <20070531102603.GA16719@srcf.ucam.org> <20070601074606.GA6060@dose.home.local> <20070601125422.GA12204@srcf.ucam.org> <20070604093518.GA29240@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604093518.GA29240@dose.home.local>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: RTC_DRV_CMOS can break userspace interface
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 11:35:18AM +0200, Tino Keitel wrote:

(By the way, it helps if you Cc: me - it's easy to lose track of things 
in the LKML noise)

> Here it is:
> 
> state = active
> io 0x70-0x77
> options

Yes, there's no IRQ listed. Can you try current git?
-- 
Matthew Garrett | mjg59@srcf.ucam.org
