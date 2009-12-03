Return-Path: <linux-kernel-owner+w=401wt.eu-S1756207AbZLCOVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbZLCOVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 09:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbZLCOVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 09:21:16 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44394 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbZLCOVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 09:21:16 -0500
Date: Thu, 3 Dec 2009 09:21:18 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Helge Deller <deller@gmx.de>, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org, kyle@mcmartin.ca,
       akpm@linux-foundation.org, James.Bottomley@hansenpartnership.com,
       roland@redhat.com, dave@hiauly1.hia.nrc.ca,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] modules: don't export section names of empty sections
	via sysfs
Message-ID: <20091203142118.GQ28962@bombadil.infradead.org>
References: <20091202232915.GA2251@p100.box> <200912031750.41240.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912031750.41240.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 05:50:41PM +1030, Rusty Russell wrote:
> On Thu, 3 Dec 2009 09:59:15 am Helge Deller wrote:
> > [PATCH] modules: don't export section names of empty sections via sysfs
> 
> Thanks, applied.
> 
> Ah, I see Linus snuck this in before the release.  Excellent.
> Rusty.
> 

Thanks Rusty, Helge!

cheers, Kyle
