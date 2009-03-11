Return-Path: <linux-kernel-owner+w=401wt.eu-S1752570AbZCKVAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbZCKVAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 17:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbZCKVAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 17:00:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:34702 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbZCKVAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 17:00:37 -0400
Message-ID: <49B8261D.7020805@kernel.org>
Date: Wed, 11 Mar 2009 13:59:09 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] PCI fixes for 2.6.29
References: <20090311043659.GC25995@parisc-linux.org> <alpine.LFD.2.00.0903111220200.32478@localhost.localdomain> <20090311201337.GI25995@parisc-linux.org> <86802c440903111336v7b5c3e3jc5bb3afd9da8f42e@mail.gmail.com> <20090311204834.GJ25995@parisc-linux.org>
In-Reply-To: <20090311204834.GJ25995@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Wed, Mar 11, 2009 at 01:36:05PM -0700, Yinghai Lu wrote:
>> please don't use that one. and use "pci: don't disable too many HT MSI
>> mapping -v4" instead
> 
> I already said I'm not comfortable applying a patch that intrusive at
> this stage of -rc7.  I don't understand it nearly well enough, and given
> that v1 ended up *not* solving the problem, and neither did v2 or v3,
> I'm not convinced you understand it well enough either.  I think v4 is
> appropriate for applying during the 2.6.30 merge window.
> 
> If you can find someone who really does understand it to review it and
> agree it's OK for a post-rc7 merge, I'll consider changing my mind.
> 

OK
v4 for 2.6.30. and later could push that back to 29 stabe later if needed.

YH
