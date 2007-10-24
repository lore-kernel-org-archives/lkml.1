Return-Path: <linux-kernel-owner+w=401wt.eu-S1758906AbXJXNpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906AbXJXNpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 09:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757017AbXJXNpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 09:45:44 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:2251 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755565AbXJXNpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 09:45:43 -0400
Date: Wed, 24 Oct 2007 15:45:41 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 09/10] Change table chaining layout
Message-ID: <20071024134541.GB39386@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Linux Kernel Development <linux-kernel@vger.kernel.org>,
	Linux/m68k <linux-m68k@vger.kernel.org>
References: <20071023094142.GD5059@kernel.dk> <471DC3D9.2070809@panasas.com> <20071023095507.GE5059@kernel.dk> <471DCBB2.9020706@panasas.com> <alpine.LFD.0.999.0710230808260.30120@woody.linux-foundation.org> <20071024080549.GZ14671@kernel.dk> <Pine.LNX.4.64.0710241103000.5840@anakin> <20071024091242.GK14671@kernel.dk> <20071024133553.GA39386@dspnet.fr.eu.org> <20071024133804.GB14671@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024133804.GB14671@kernel.dk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 03:38:04PM +0200, Jens Axboe wrote:
> (please don't drop cc lists)

Sorry.  Reactions of people to Cc vary...


> That doesn't make any sense. Both sg_set_buf() and sg_set_page() set the
> same thing in the sg entry, the input is just different. It has nothing
> to do with setting the physical value, for instance.

Ok.  I misunderstood the sg_virt/sg_phys difference I guess.  No
problem.

  OG.
