Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbZKLV6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbZKLV6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 16:58:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754444AbZKLV6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 16:58:35 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:3403 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbZKLV6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 16:58:34 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAGsU/EqrR7Hu/2dsb2JhbADFHJgYhDwE
X-IronPort-AV: E=Sophos;i="4.44,731,1249257600"; 
   d="scan'208";a="431273214"
Date: Thu, 12 Nov 2009 16:58:40 -0500
From: David VomLehn <dvomlehn@cisco.com>
To: Matt Mackall <mpm@selenic.com>
Cc: linux-embedded@vger.kernel.org, akpm@linux-foundation.org,
       dwm2@infradead.org, linux-kernel@vger.kernel.org,
       paul.gortmaker@windriver.com
Subject: Re: [PATCH, RFC] panic-note: Annotation from user space for panics
Message-ID: <20091112215840.GB28349@dvomlehn-lnx2.corp.sa.net>
References: <20091112021322.GA6166@dvomlehn-lnx2.corp.sa.net> <1258049211.10621.40.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258049211.10621.40.camel@calx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 01:06:51PM -0500, Matt Mackall wrote:
> On Wed, 2009-11-11 at 21:13 -0500, David VomLehn wrote:
> > Allows annotation of panics to include platform information. It's no big
> > deal to collect information, but way helpful when you are collecting
> > failure reports from a eventual base of millions of systems deployed in
> > other people's homes.
> 
> I'd like to hear a bit more use case motivation on this feature. Also,
> why do you want more than a page?

Hopefully, I have addressed the first question in my previous email. As
for the second, I doubt there is a need for more than a page. I just picked
a value to start developing with. This is still a work in progress...

> http://selenic.com : development and support for Mercurial and Linux

David VL
