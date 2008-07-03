Return-Path: <linux-kernel-owner+w=401wt.eu-S1758522AbYGCMR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522AbYGCMR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754306AbYGCMRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:17:17 -0400
Received: from john.hrz.tu-chemnitz.de ([134.109.132.2]:60923 "EHLO
	john.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbYGCMRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:17:16 -0400
Date: Thu, 3 Jul 2008 14:17:12 +0200
From: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       davem@davemloft.net, dhowells@redhat.com, jgarzik@pobox.com
Subject: Re: [patch 03/04] 3c59x: handle pci_name() being const
Message-ID: <20080703121712.GA3376@bayes.mathematik.tu-chemnitz.de>
References: <20080702200902.909349505@mini.kroah.org> <20080702202453.GC14024@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080702202453.GC14024@kroah.com>
User-Agent: Mutt/1.4.2.1i
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.5 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: c4f9a1b1b5ab3573312a634ab222e80e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 01:24:53PM -0700, Greg Kroah-Hartman wrote:
> This changes vortex_prob1() to handle pci_name() now returning a
> constant string.
> 
I got the same patch from David Howells already,
that one is acked and send to Jeff Garzik.

Steffen
