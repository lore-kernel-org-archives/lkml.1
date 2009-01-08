Return-Path: <linux-kernel-owner+w=401wt.eu-S1760906AbZAHRBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760906AbZAHRBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 12:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbZAHRBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 12:01:25 -0500
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:48033 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbZAHRBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 12:01:24 -0500
Date: Thu, 8 Jan 2009 18:01:18 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: gregkh@suse.de, torvalds@linux-foundation.org, inaky@linux.intel.com,
       schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wimax: fix compile bug
Message-ID: <20090108170118.GD4821@osiris.boeblingen.de.ibm.com>
References: <20090108161222.GC4821@osiris.boeblingen.de.ibm.com> <20090108165254.GA13737@suse.de> <20090108.085806.43922610.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090108.085806.43922610.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 08:58:06AM -0800, David Miller wrote:
> From: Greg KH <gregkh@suse.de>
> Date: Thu, 8 Jan 2009 08:52:54 -0800
> 
> > On Thu, Jan 08, 2009 at 05:12:22PM +0100, Heiko Carstens wrote:
> > > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > > 
> > > wimax should depend on INPUT:
> > 
> > <snip>
> > 
> > Inaky just sent a series of 3 patches to the netdev mailing list fixing
> > this up in a much better way.
> 
> Yep, I'll be integrating his patches during the course of
> today.

Even better. Thanks!
