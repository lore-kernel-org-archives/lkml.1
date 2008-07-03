Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbYGCPyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbYGCPyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 11:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbYGCPyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 11:54:23 -0400
Received: from ns2.suse.de ([195.135.220.15]:42357 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbYGCPyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 11:54:22 -0400
Date: Thu, 3 Jul 2008 08:43:47 -0700
From: Greg KH <gregkh@suse.de>
To: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       davem@davemloft.net, dhowells@redhat.com, jgarzik@pobox.com
Subject: Re: [patch 03/04] 3c59x: handle pci_name() being const
Message-ID: <20080703154347.GA12460@suse.de>
References: <20080702200902.909349505@mini.kroah.org> <20080702202453.GC14024@kroah.com> <20080703121712.GA3376@bayes.mathematik.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080703121712.GA3376@bayes.mathematik.tu-chemnitz.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 02:17:12PM +0200, Steffen Klassert wrote:
> On Wed, Jul 02, 2008 at 01:24:53PM -0700, Greg Kroah-Hartman wrote:
> > This changes vortex_prob1() to handle pci_name() now returning a
> > constant string.
> > 
> I got the same patch from David Howells already,
> that one is acked and send to Jeff Garzik.

Great, thanks for letting us know.

greg k-h
