Return-Path: <linux-kernel-owner+w=401wt.eu-S1753939AbZKLSIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbZKLSIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 13:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753599AbZKLSIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 13:08:15 -0500
Received: from waste.org ([173.11.57.241]:59344 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753460AbZKLSIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 13:08:14 -0500
Subject: Re: [PATCH, RFC] panic-note: Annotation from user space for panics
From: Matt Mackall <mpm@selenic.com>
To: David VomLehn <dvomlehn@cisco.com>
Cc: linux-embedded@vger.kernel.org, akpm@linux-foundation.org,
       dwm2@infradead.org, linux-kernel@vger.kernel.org,
       paul.gortmaker@windriver.com
In-Reply-To: <20091112021322.GA6166@dvomlehn-lnx2.corp.sa.net>
References: <20091112021322.GA6166@dvomlehn-lnx2.corp.sa.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Nov 2009 12:06:51 -0600
Message-ID: <1258049211.10621.40.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-11 at 21:13 -0500, David VomLehn wrote:
> Allows annotation of panics to include platform information. It's no big
> deal to collect information, but way helpful when you are collecting
> failure reports from a eventual base of millions of systems deployed in
> other people's homes.

I'd like to hear a bit more use case motivation on this feature. Also,
why do you want more than a page?

-- 
http://selenic.com : development and support for Mercurial and Linux


