Return-Path: <linux-kernel-owner+w=401wt.eu-S935032AbZDHReK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935032AbZDHReK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 13:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934982AbZDHRdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 13:33:35 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:46425 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934838AbZDHRdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 13:33:33 -0400
Date: Wed, 8 Apr 2009 11:33:32 -0600
From: Alex Chiang <achiang@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org
Subject: Re: cross-compilers
Message-ID: <20090408173332.GB20187@ldl.fc.hp.com>
References: <20090408003921.GA5054@ldl.fc.hp.com> <20090408010331.GB10768@sgi.com> <20090408054612.GA6744@ldl.fc.hp.com> <20090407225457.86f8a458.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090407225457.86f8a458.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org>:
> On Tue, 7 Apr 2009 23:46:12 -0600 Alex Chiang <achiang@hp.com> wrote:
> 
> > * Robin Holt <holt@sgi.com>:
> > > Don't know if this answers your problem, but I use the tools from
> > > emdebian and they do not suffer from the problems you list below.
> > 
> > Wow, this seems _much_ simpler. Once you get the toolchain
> > installed, all you have to do is set ARCH and CROSS_COMPILE
> > appropriately?
> > 
> > I guess the question remains for Andrew. Since I pretty much did
> > all the work needed to update his cross-compiler repo, is there
> > still value in it?
> 
> We would benefit very much from having someone who actually maintains a
> suite of cross-compilers for kernel developers.
 
Ok, I'll work with Vegard on this.

Thanks.

/ac

