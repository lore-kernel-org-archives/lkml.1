Return-Path: <linux-kernel-owner+w=401wt.eu-S1756325AbZC0DDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325AbZC0DDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 23:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953AbZC0DD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 23:03:26 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50264 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbZC0DDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 23:03:25 -0400
Date: Fri, 27 Mar 2009 03:03:20 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: David Rees <drees76@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090327030320.GB16343@srcf.ucam.org>
References: <20090325183011.GN32307@mit.edu> <alpine.LFD.2.00.0903251139260.3032@localhost.localdomain> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <72dbd3150903261921k7cf728ebhf331e9965630be7e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72dbd3150903261921k7cf728ebhf331e9965630be7e@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 07:21:08PM -0700, David Rees wrote:

> Does *any* distro fiddle those bits in userspace instead of patching the kernel?

Given that the optimal values of these tunables often seems to vary 
between kernel versions, it's easier to just put them in the kernel. 

-- 
Matthew Garrett | mjg59@srcf.ucam.org
