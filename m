Return-Path: <linux-kernel-owner+w=401wt.eu-S1753220AbZGVU4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbZGVU4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 16:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbZGVU4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 16:56:13 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35951 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbZGVU4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 16:56:12 -0400
Date: Wed, 22 Jul 2009 21:55:51 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Miller <davem@davemloft.net>,
       swetland@google.com, pavel@ucw.cz, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, san@android.com,
       rlove@google.com
Subject: Re: ARM platform trees (was: Re: HTC Dream aka. t-mobile g1
	support)
Message-ID: <20090722205551.GB1575@n2100.arm.linux.org.uk>
References: <20090611111821.GK795@n2100.arm.linux.org.uk> <20090611.042226.28424489.davem@davemloft.net> <20090611114911.GL795@n2100.arm.linux.org.uk> <20090611.050030.169859977.davem@davemloft.net> <20090611123852.GM795@n2100.arm.linux.org.uk> <20090611135442.6b9ab315@lxorguk.ukuu.org.uk> <20090611131245.GN795@n2100.arm.linux.org.uk> <87skgok3i9.fsf_-_@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87skgok3i9.fsf_-_@deeprootsystems.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 10:54:06AM -0700, Kevin Hilman wrote:
> Russell King - ARM Linux <linux@arm.linux.org.uk> writes:
> 
> > On Thu, Jun 11, 2009 at 01:54:42PM +0100, Alan Cox wrote:
> >> Make your tree the core ARM code only, any other patches you don't
> >> accept. Aggressively push stuff out to platform code, and if people want
> >> to change core code "because our platform is different" make them extract
> >> it into the platform layer not carry it in the core bits.
> >
> > I'm all for giving this a try after this merge window is over.
> 
> So, in preparation for the next merge window...
> 
> Is there an official way for ARM platform maintainers like myself to
> get stuff merged via Linus' tree?  Is simply sending a pull request to
> Linus/LKML all that's required?

Yup.
