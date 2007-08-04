Return-Path: <linux-kernel-owner+w=401wt.eu-S933238AbXHDUES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238AbXHDUES (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 16:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763070AbXHDUEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 16:04:10 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:42983 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762892AbXHDUEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 16:04:09 -0400
Date: Sat, 4 Aug 2007 22:05:25 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Rob Landley <rob@landley.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] Documentation/make/headers_install.txt
Message-ID: <20070804200525.GA21961@uranus.ravnborg.org>
References: <200708041307.18578.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708041307.18578.rob@landley.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2007 at 02:07:18PM -0400, Rob Landley wrote:
> From: Rob Landley <rob@landley.net>
> 
> Signed-off-by: Rob Landley <rob@landley.net>
> 
> Some documentation for "make headers_install".
> 
> ---
> 
> Earlier discussion was at http://lkml.org/lkml/2007/6/22/7 and I
> believe I've responded to all of David's comments.
> 
> --- /dev/null	2007-04-23 10:59:00.000000000 -0500
> +++ linux-2.6/Documentation/make/headers_install.txt	2007-08-04 13:04:51.000000000 -0500

Any specific reason not to include this in Documentation/kbuild?
I would prefer to have all kernel build stuff in one directory and
we have Documentation/kbuild now.

	Sam
