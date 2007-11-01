Return-Path: <linux-kernel-owner+w=401wt.eu-S1760262AbXKAXdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760262AbXKAXdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 19:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755758AbXKAXda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 19:33:30 -0400
Received: from mail-03.jhb.wbs.co.za ([196.2.97.2]:35801 "EHLO
	mail-03.jhb.wbs.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbXKAXd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 19:33:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsxMAEb/KUfEAmHGRmdsb2JhbACOXgEBARIJHA4
From: Bongani Hlope <bonganilinux@mweb.co.za>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: irq 21: nobody cared 2.6.24-rc1
Date: Fri, 2 Nov 2007 01:33:28 +0200
User-Agent: KMail/1.9.8
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
References: <200710251045.37040.bonganilinux@mweb.co.za> <20071101133238.16bb9a3f.akpm@linux-foundation.org>
In-Reply-To: <20071101133238.16bb9a3f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711020133.28907.bonganilinux@mweb.co.za>
X-Original-Subject: Re: irq 21: nobody cared 2.6.24-rc1
X-Spam-Score: 1.0 (+)
X-Spam-Score-Int: 10
X-Spam-Report: Spam detection software, running on the system "wbs-smtp-out-03.jhb.wbs.co.za", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	Postmaster for details.
	Content preview:  On Thursday 01 November 2007 22:32:38 Andrew Morton wrote:
	> On Thu, 25 Oct 2007 10:45:36 +0200 > > Bongani Hlope <bonganilinux@mweb.co.za>
	wrote: > > Booting with irqpoll works > > > > ls /proc/irq/21/ (with irqpoll)
	> > ehci_hcd:usb1/ smp_affinity uhci_hcd:usb2/ uhci_hcd:usb3/ > > uhci_hcd:usb4/
	> > > > Disabling IRQ #21 > > Was any earlier kernel version OK? 2.6.23?
	[...] 
	Content analysis details:   (1.0 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
	0.9 RCVD_IN_PBL            RBL: Received via a relay in Spamhaus PBL
	[196.2.114.125 listed in zen.spamhaus.org]
	0.1 RDNS_DYNAMIC           Delivered to trusted network by host with
	dynamic-looking rDNS
X-Scan-Signature: bc494251cc6766af3c8ae5601359c165
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 November 2007 22:32:38 Andrew Morton wrote:
> On Thu, 25 Oct 2007 10:45:36 +0200
>
> Bongani Hlope <bonganilinux@mweb.co.za> wrote:
> > Booting with irqpoll works
> >
> > ls /proc/irq/21/ (with irqpoll)
> > ehci_hcd:usb1/  smp_affinity  uhci_hcd:usb2/  uhci_hcd:usb3/ 
> > uhci_hcd:usb4/
> >
> >  Disabling IRQ #21
>
> Was any earlier kernel version OK?  2.6.23?

Yes the 2.6.23 kernel works fine. This seems to happen when I boot the 
2.6.24-rc1 kernel with an iPod attached (hope this helps), but the 2.6.23 
kernel doesn't experience this problem.

