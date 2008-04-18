Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbYDRGof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbYDRGof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 02:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbYDRGo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 02:44:26 -0400
Received: from ozlabs.org ([203.10.76.45]:40725 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbYDRGoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 02:44:25 -0400
Subject: Re: [PATCH 1/2] Add thread_info_cache_init() to all archs
From: Benjamin Herrenschmidt <benh@ozlabs.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org, takata@linux-m32r.org,
       linux-m32r@ml.linux-m32r.org, Linux-Arch <linux-arch@vger.kernel.org>
In-Reply-To: <20080417211905.8ff769fa.akpm@linux-foundation.org>
References: <20080410032354.90CB1DDF0F@ozlabs.org>
	 <20080413171953.bde5e9ac.akpm@linux-foundation.org>
	 <1208133506.6958.82.camel@pasglop>
	 <20080413191338.9776ebd0.akpm@linux-foundation.org>
	 <1208491086.6958.381.camel@pasglop>
	 <20080417211905.8ff769fa.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 18 Apr 2008 16:44:21 +1000
Message-Id: <1208501061.6958.394.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > so what
> > about the patch below ?
> 
> I like it, but the compiler won't ;)
> 
> > If you're ok, I'll re-send with appropriate sob
> > & adapted powerpc part.
> 
> Sure.
> 
> > +void __init __attribute__((weak) thread_info_cache_init(void)
> 
> s/weak)/weak))/

Yeah, missing quilt ref :-)

I'll send the proper patches in a minute.

Cheers,
Ben.


