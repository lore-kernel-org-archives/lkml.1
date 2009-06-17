Return-Path: <linux-kernel-owner+w=401wt.eu-S1756190AbZFQQEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbZFQQEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbZFQQDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:03:43 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:47012 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbZFQQDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:03:42 -0400
Date: Wed, 17 Jun 2009 10:03:43 -0600
From: Alex Chiang <achiang@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Patterson <andrew.patterson@hp.com>, linux-pci@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH 0/1] Recurse when searching for empty slots in
	resources trees
Message-ID: <20090617160343.GA11935@ldl.fc.hp.com>
References: <20090616220419.14021.84524.stgit@bob.kio> <alpine.LFD.2.01.0906161511390.16802@localhost.localdomain> <1245192703.8234.226.camel@bluto.andrew> <alpine.LFD.2.01.0906161556020.16802@localhost.localdomain> <1245195498.8234.236.camel@bluto.andrew> <alpine.LFD.2.01.0906161640250.16802@localhost.localdomain> <20090616172811.7f6374f4@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616172811.7f6374f4@jbarnes-g45>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jesse Barnes <jbarnes@virtuousgeek.org>:
> 
> Alex has been fixing up hotplug related code recently too; Alex?  Also
> you didn't actually include a patch in your last mail that I could
> see...

Oh, I'm well aware that Andrew has been working on this, and am
happy to let him keep driving. :)

I may drag out my old machine that I use to test cpqphp and see
if we have the same issues there, as it's x86, and I did notice
some BAR collisions last time I checked.

Thanks.

/ac

