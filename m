Return-Path: <linux-kernel-owner+w=401wt.eu-S1759150AbXJZUVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759150AbXJZUVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 16:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbXJZUVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 16:21:13 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:54378 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbXJZUVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 16:21:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CcyI17liJWEYGyMi3dzT2XdDHETSXBWz7KlkIO4JT8aRVoAF3cfm4Fj97IU+D4iQSp91T2NBjLeJ7tvA7putHiGs20PH+sifgUvzIj0tCrS/9e7O41ekSUpQ7hRd/mWGYlDNZ/g+G+8VuITFjf6ZvAAGA4Wikc2qXK4gQeQWLS8=
Message-ID: <cfd18e0f0710261321n7e480e7bt963bce677927864a@mail.gmail.com>
Date: Fri, 26 Oct 2007 16:21:11 -0400
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Cc: "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>, rientjes@google.com,
       clameter@sgi.com, akpm@linux-foundation.org, ak@suse.de,
       linux-kernel@vger.kernel.org, mtk-manpages@gmx.net
In-Reply-To: <20071026100451.c0742740.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	 <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
	 <20071025185506.8c373aa8.pj@sgi.com>
	 <alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com>
	 <20071025192945.82962eea.pj@sgi.com>
	 <alpine.DEB.0.9999.0710251937100.2989@chino.kir.corp.google.com>
	 <20071025201455.acb4e72c.pj@sgi.com>
	 <alpine.DEB.0.9999.0710252049590.18868@chino.kir.corp.google.com>
	 <1193413054.5032.20.camel@localhost>
	 <20071026100451.c0742740.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/07, Paul Jackson <pj@sgi.com> wrote:
> Lee wrote:
> > Paul:  what do you think about subsetting the cpuset.txt into a man page
> > or 2 that can be referenced by other man pages' See Also sections?
>
> Oh dear --- looking back in my work queue I have with my employer, I
> see I have a task that is now over a year old, still unfinished, to
> provide man pages for cpusets to Michael Kerrisk" <mtk-manpages@gmx.net>

Yes, it would be great to have those pages.  Is there anything I can
do to assist?

Cheers,

Michael

PS Note my new addres for man-apges: mtk.manpages@gmail.com
