Return-Path: <linux-kernel-owner+w=401wt.eu-S1752303AbXJWIjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbXJWIjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 04:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbXJWIjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 04:39:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:60892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbXJWIjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 04:39:09 -0400
Date: Tue, 23 Oct 2007 10:39:05 +0200
From: Jan Blunck <jblunck@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, bharata@linux.vnet.ibm.com, agruen@suse.de,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/13] Use struct path in struct nameidata
Message-ID: <20071023083905.GI17591@hasse.suse.de>
References: <20071022065352.GA6489@in.ibm.com> <20071022135758.GA17051@lst.de> <20071022155634.f61c9d43.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022155634.f61c9d43.akpm@linux-foundation.org>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG
	Nuernberg)
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, Andrew Morton wrote:

> On Mon, 22 Oct 2007 15:57:58 +0200
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > 
> > Any reason we've got this patchset posted by three people now? :)
> 
> presumably because I haven't been merging it.
> 
> I was in bugfix-only mode from a week prior to 2.6.24 release and during
> the merge window.  Partly caused by the already-idiotic amount of stuff we
> had queued for 2.6.24, partly because we needed to concentrate on
> stabilising the 2.6.25 patchpile rather than writing new stuff.
> 
> And partly to send the signal that rather than beavering away on new
> features all the time, we should also be spending some (more) time testing,
> reviewing and bugfixing the current and soon-to-be-current code.
> 
> Probably I should have been more explicit about it, but it wasn't really
> planned.  Next time I'll send more "thanks, I parked this for consideration
> at a more appropriate time" emails.

Oh, I got that one. I don't know why Bharata sent the patch series
again. Especially since I don't know which version of the patches he sent out :(

The original patches where rotting in my queue for quite some time until
Andreas got fed up with me having no time to work on them. Now since Andreas
is busy working on other things I took over again. Thats it.
