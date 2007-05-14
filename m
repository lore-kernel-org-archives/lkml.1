Return-Path: <linux-kernel-owner+w=401wt.eu-S965880AbXENLEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965880AbXENLEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 07:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758765AbXENLES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 07:04:18 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:40503 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757628AbXENLER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 07:04:17 -0400
Date: Mon, 14 May 2007 13:05:10 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Li Yang <leoli@freescale.com>
Cc: Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: fix wrong warning message in modpost
Message-ID: <20070514110510.GA10143@uranus.ravnborg.org>
References: <4648342C.3020208@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4648342C.3020208@freescale.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2007 at 06:04:28PM +0800, Li Yang wrote:
> One of the "Section mismatch" warning message in modpost.c
> is in wrong format.  This patch fix it.
Thanks.
I have another patch from Russell King that
fixes this and on top of that makes the warnings more
readable. So I will apply his patch.

	Sam
