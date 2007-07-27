Return-Path: <linux-kernel-owner+w=401wt.eu-S937373AbXG0U15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937373AbXG0U15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 16:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761532AbXG0U1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 16:27:48 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:38123 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759965AbXG0U1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 16:27:47 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch] x86, serial: always probe for legacy COM ports
Date: Fri, 27 Jul 2007 14:26:30 -0600
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>, Adam Belay <ambx1@neo.rr.com>,
       Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       =?iso-8859-15?q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200707271158.50028.bjorn.helgaas@hp.com> <200707271411.42253.bjorn.helgaas@hp.com> <46AA53E3.5080501@garzik.org>
In-Reply-To: <46AA53E3.5080501@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707271426.30962.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 July 2007 02:21:55 pm Jeff Garzik wrote:
> Bjorn Helgaas wrote:
> > On Friday 27 July 2007 12:05:51 pm Jeff Garzik wrote:
> >> This is still incomplete, as repeatedly stated.  Here is the email, again.
> 
> > OK, uncle!  I'll work on your helpful advice (thanks for that), but
> > it feels too risky for this stage of 2.6.23.  Maybe I can come up with
> > something for a future release.
> 
> The changeset in the kernel is too risky _without_ the changes I described.

That's what I meant.  Andrew already has a revert patch in -mm, and
the safest path seems like putting the reversion in 2.6.23 and working
on your advice post-2.6.23.

Bjorn

