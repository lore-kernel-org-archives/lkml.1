Return-Path: <linux-kernel-owner+w=401wt.eu-S1761649AbXGESyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761649AbXGESyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 14:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760014AbXGESyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 14:54:09 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:47944 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759842AbXGESyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 14:54:08 -0400
Date: Thu, 5 Jul 2007 12:54:06 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linas Vepstas <linas@austin.ibm.com>, James.Bottomley@steeleye.com,
       willy@debian.org, linux-scsi@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH]: PCI Error Recovery: Symbios SCSI device driver
Message-ID: <20070705185406.GA3527@parisc-linux.org>
References: <20070702183917.GJ4501@austin.ibm.com> <20070705112838.2d8c959b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070705112838.2d8c959b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2007 at 11:28:38AM -0700, Andrew Morton wrote:
> Well you've sent it a couple of times, and I've sent it in five more times
> over the past year.  Once we were told "awaiting maintainer ack".
> 
> This situation is fairly stupid.  How about we make you the maintainer?

Last time I looked at it, I still wasn't comfortable with it.  I'm going
to look at it again.

I'm fairly sure Linas doesn't want to be the sym2 maintainer.  It's
still an ugly pile of junk that needs cleaning up.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
