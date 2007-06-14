Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbXFNRaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbXFNRaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 13:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbXFNR35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 13:29:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39693 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbXFNR35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 13:29:57 -0400
Date: Thu, 14 Jun 2007 10:30:51 -0700
From: Greg KH <greg@kroah.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-stable <stable@kernel.org>, Dave Jones <davej@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, dsd@gentoo.org
Subject: Re: [stable]  libata spindown patches for 2.6.21-stable
Message-ID: <20070614173051.GA9039@kroah.com>
References: <4671664A.8010404@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4671664A.8010404@redhat.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

<added Daniel to CC:>

On Thu, Jun 14, 2007 at 12:01:14PM -0400, Chuck Ebbert wrote:
> Should we put these patches in 2.6.21-stable?
> 
> Gentoo developers did a full backport:
> 
> http://marc.info/?l=linux-ide&m=118047865916766&w=2

I think it looks way too big.

If there are smaller patches, it might be a bit more reasonable.

Are there reported bugs that this patchset fixes?

thanks,

greg k-h
