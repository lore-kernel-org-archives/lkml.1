Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbYHGMYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbYHGMYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754414AbYHGMXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:23:30 -0400
Received: from lana.hrz.tu-chemnitz.de ([134.109.132.3]:33420 "EHLO
	lana.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345AbYHGMXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:23:11 -0400
Date: Thu, 7 Aug 2008 12:18:43 +0200
From: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       davem@davemloft.net, dhowells@redhat.com
Subject: Re: [patch 03/04] 3c59x: handle pci_name() being const
Message-ID: <20080807101843.GA24655@bayes.mathematik.tu-chemnitz.de>
References: <20080702200902.909349505@mini.kroah.org> <20080702202453.GC14024@kroah.com> <20080703121712.GA3376@bayes.mathematik.tu-chemnitz.de> <489A96D1.4040108@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <489A96D1.4040108@pobox.com>
User-Agent: Mutt/1.4.2.1i
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.5 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: f69c3b77c4b3e26dd0b52dac0e0ea9f8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2008 at 02:31:45AM -0400, Jeff Garzik wrote:
> Steffen Klassert wrote:
> >On Wed, Jul 02, 2008 at 01:24:53PM -0700, Greg Kroah-Hartman wrote:
> >>This changes vortex_prob1() to handle pci_name() now returning a
> >>constant string.
> >>
> >I got the same patch from David Howells already,
> >that one is acked and send to Jeff Garzik.
> 
> could you resend, I only have the patch in quoted email...
 
The "3c59x: handle pci_name() being const" patch is already
mainline, so there is no need to resend.

Steffen
