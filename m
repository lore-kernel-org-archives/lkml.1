Return-Path: <linux-kernel-owner+w=401wt.eu-S932600AbXBJPll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600AbXBJPll (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 10:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932608AbXBJPll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 10:41:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40935 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932600AbXBJPll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 10:41:41 -0500
From: Andi Kleen <ak@suse.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: remote debugging via FireWire
Date: Sat, 10 Feb 2007 16:41:36 +0100
User-Agent: KMail/1.9.5
Cc: Bernhard Kaindl <bk@suse.de>, discuss@x86-64.org,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <200702101242.48467.ak@suse.de> <200702101502.59431.ak@suse.de> <45CDE14C.4040203@s5r6.in-berlin.de>
In-Reply-To: <45CDE14C.4040203@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702101641.36239.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 February 2007 16:14, Stefan Richter wrote:
> Andi Kleen wrote:
> > On Saturday 10 February 2007 14:51, Stefan Richter wrote:
> >> Could be handled via linux1394-2.6.git, although a
> >> different channel where the actual users of this facility watch would
> >> IMO be more appropriate.
> > 
> > It's more related to arch code than firewire, so I thought i would
> > handle it. But you can too if you want. It definitely needs much
> > more review anyways.
> 
> It's better you do it. I don't know anything about the specifics of
> early initialization. Just Cc linux1394-devel on submission so that we
> can have a look at the OHCI-1394 related bits.

Ok. I'm sure you know more about 1394 than me so I guess it will be shared
review.

-Andi
