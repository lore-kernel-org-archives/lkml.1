Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbYGYVnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbYGYVnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 17:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbYGYVnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 17:43:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:59211 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbYGYVnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 17:43:47 -0400
Subject: Re: [git pull] Please pull from powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       akpm <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <BAF7B55C-75C2-4BCA-8686-34A843865C91@kernel.crashing.org>
References: <1216973590.11188.99.camel@pasglop>
	 <BAF7B55C-75C2-4BCA-8686-34A843865C91@kernel.crashing.org>
Content-Type: text/plain
Date: Sat, 26 Jul 2008 07:43:08 +1000
Message-Id: <1217022188.11188.112.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-25 at 10:07 -0500, Kumar Gala wrote:
> On Jul 25, 2008, at 3:13 AM, Benjamin Herrenschmidt wrote:
> 
> >
> > Benjamin Herrenschmidt (1):
> >      Move update_mmu_cache() declaration from tlbflush.h to pgtable.h
> 
> I'm guessing this was pretty trivial, but please post patches to the  
> list even if you've committed them to your tree.

This was a last minute build fix I stuck in to ... fix the build :-)
Some new stuff from Christoph Lameter broke ppc32 build without that
fix.

Next time I'll also send it to the list as well.

Ben.


