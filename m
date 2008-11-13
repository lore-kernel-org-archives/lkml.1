Return-Path: <linux-kernel-owner+w=401wt.eu-S1756780AbYKMWPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbYKMWPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 17:15:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756482AbYKMWOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 17:14:31 -0500
Received: from kroah.org ([198.145.64.141]:33745 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756026AbYKMWO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 17:14:29 -0500
Date: Thu, 13 Nov 2008 14:09:54 -0800
From: Greg KH <greg@kroah.com>
To: Paul Mackerras <paulus@samba.org>
Cc: stable@kernel.org, Kumar Gala <galak@kernel.crashing.org>,
       linux-kernel Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [stable] Fwd: [PATCH v2][for 2.6.28] powerpc/mpic: Add support
	for MPICs that only support a single CPU destination
Message-ID: <20081113220954.GC15628@kroah.com>
References: <1225252899-20752-1-git-send-email-galak@kernel.crashing.org> <B48FBC1A-5974-4E68-B34A-39C223328EFF@kernel.crashing.org> <20081111211801.GB2497@kroah.com> <18714.14081.378730.381602@drongo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18714.14081.378730.381602@drongo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 12:53:05PM +1100, Paul Mackerras wrote:
> Greg KH writes:
> 
> > > Can you pick this up for stable-2.6.27.
> > 
> > I don't see this in Linus's tree right now.
> > 
> > Am I missing it?  Or do you know what the git commit id is?
> 
> It's 3c10c9c45e290022ca7d2aa1ad33a0b6ed767520.  I changed the title to
> "powerpc/mpic: Fix regression caused by change of default IRQ
> affinity" and expanded the patch description to emphasize that it was
> fixing a regression rather than just adding a feature.

Thanks, now queued up.

greg k-h
