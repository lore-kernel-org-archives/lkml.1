Return-Path: <linux-kernel-owner+w=401wt.eu-S1751429AbZJGEMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbZJGEMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 00:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbZJGEMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 00:12:46 -0400
Received: from mail-qy0-f202.google.com ([209.85.221.202]:58779 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbZJGEMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 00:12:46 -0400
X-Greylist: delayed 418 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Oct 2009 00:12:46 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=yFLm7D1LooAgvIBo9tRMGWK3q9G5u+A2bf5XURvF6N8GBCGrCW2iBOxYQrSzyTKuEc
         LRRbei+Pnp5z3H5fr1KGXwurRwC9mNtyG4jQru3e/GOF9ouWuSZTyGrJ4/kvsNaT1lak
         BDEIJXlQ+kkFzqdu6HPGG4qVvonJlmwOPLXC8=
Subject: Re: [RFC][PATCH 8/9] perf trace: Add perf trace scripting support
 modules for Perl
From: Tom Zanussi <tzanussi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, hch@infradead.org
In-Reply-To: <20091006124550.GB15320@elte.hu>
References: <1254809398-8078-1-git-send-email-tzanussi@gmail.com>
	 <1254809398-8078-9-git-send-email-tzanussi@gmail.com>
	 <20091006124550.GB15320@elte.hu>
Content-Type: text/plain
Date: Tue, 06 Oct 2009 23:05:04 -0500
Message-Id: <1254888304.28917.124.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 14:45 +0200, Ingo Molnar wrote:
> * Tom Zanussi <tzanussi@gmail.com> wrote:
> 
> > +++ b/tools/perf/scripts/perl/Perf-Trace-Util/README
> > @@ -0,0 +1,30 @@
> > +Perf-Trace-Util version 0.01
> > +============================
> > +
> > +This module contains utility functions for use with perf trace.
> > +
> > +INSTALLATION
> > +
> > +Building perf with perf trace Perl scripting should install this
> > +module in the right place.
> > +
> > +You should make sure libperl is installed first e.g. apt-get install
> > +libperl-dev.
> > +
> > +DEPENDENCIES
> > +
> > +This module requires these other modules and libraries:
> > +
> > +  blah blah blah
> 
> Some fixing needed here i guess ;-)

Yeah, more auto-generated stuff.

> 
> > +COPYRIGHT AND LICENCE
> > +
> > +Put the correct copyright and licence information here.
> > +
> > +Copyright (C) 2009 by Tom Zanussi <tzanussi@gmail.com>
> > +
> > +This library is free software; you can redistribute it and/or modify
> > +it under the same terms as Perl itself, either Perl version 5.10.0 or,
> > +at your option, any later version of Perl 5 you may have available.
> 
> Would be nice to dual license it to the kernel (GPLv2) as well.
> 

Right, I'll add the GPL license to this.

Thanks,

Tom

> 	Ingo

