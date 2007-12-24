Return-Path: <linux-kernel-owner+w=401wt.eu-S1752693AbXLXI3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbXLXI3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 03:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbXLXI3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 03:29:10 -0500
Received: from colo.lackof.org ([198.49.126.79]:55441 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbXLXI3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 03:29:09 -0500
Date: Mon, 24 Dec 2007 01:28:54 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Greg KH <gregkh@suse.de>
Cc: Tony Camuso <tcamuso@redhat.com>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
Message-ID: <20071224082854.GB15161@colo.lackof.org>
References: <476A5FD0.4010804@redhat.com> <20071220172205.GB5636@suse.de> <476AB3B5.9080808@redhat.com> <20071220215719.GA8528@suse.de> <476AEE7B.6050708@redhat.com> <20071220224006.GA16855@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220224006.GA16855@suse.de>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 02:40:06PM -0800, Greg KH wrote:
> Sure, I realize this, but it solves the problem in one way for broken
> hardware, such that it at least allows it to work, right?  It also
> provides a better incentive for the manufacturer to fix their bios,
> which as you are on-site at HP, it would seem odd that they would just
> not do that instead of trying to work around this in the kernel...

Greg, you know why: Cost.

Asking the BIOS provider to roll a new version costs.
Rolling the BIOS version might also require re-running the OS "Certification".
Besides the cost of an OS re-cert, BIOS changes are unlikely to happen if
it will delay the introduction and/or sale of new products.

And it's not considered to be a "BIOS" problem unless win XP (or maybe
"Vista" these days) fails the same way (which BIOS supplier would have
fixed...).

hth,
grant
