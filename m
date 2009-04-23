Return-Path: <linux-kernel-owner+w=401wt.eu-S1758018AbZDWNJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbZDWNJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 09:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753146AbZDWNJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 09:09:26 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:60711 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbZDWNJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 09:09:25 -0400
Date: Thu, 23 Apr 2009 17:09:33 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [RFC PATCH 1/2] pci: don't assume pref memio are 64bit -v3
Message-ID: <20090423130933.GA13984@jurassic.park.msu.ru>
References: <alpine.LFD.2.00.0904181602030.2199@localhost.localdomain> <alpine.LFD.2.00.0904182149240.2199@localhost.localdomain> <20090419090208.GA30211@elte.hu> <20090419090615.GA30631@elte.hu> <20090420223305.GA15340@jurassic.park.msu.ru> <49ED0EBC.4070901@kernel.org> <20090421105629.GB17904@jurassic.park.msu.ru> <49EF9C10.6090107@kernel.org> <20090423123619.GA11519@jurassic.park.msu.ru> <20090423124154.GA1397@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423124154.GA1397@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 02:41:54PM +0200, Ingo Molnar wrote:
> If you mean this "only" works on 95% of the systems that test the 
> upstream kernel then yes.
> 
> Obviously other architectural needs have to be considered too, but 
> you are making it sound as if there was some vast, more important 
> space to consider that Yinghai did not consider in his foolishness 
> ;-)

Maybe. But considering the fact that precisely 75% of the machines
I'm using everyday are alphas, I think it's excusable ;-)

Ivan.
