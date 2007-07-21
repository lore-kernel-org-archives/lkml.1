Return-Path: <linux-kernel-owner+w=401wt.eu-S1759314AbXGUQp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314AbXGUQp6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 12:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbXGUQpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 12:45:51 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:33905 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbXGUQpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 12:45:50 -0400
Date: Sun, 22 Jul 2007 01:45:23 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Rohland <hans-christoph.rohland@sap.com>,
       Christoph Rohland <ch.rohland@gmx.net>, Hugh Dickins <hugh@veritas.com>,
       Andi Kleen <ak@suse.de>, Luke Kenneth Casson Leighton <lkcl@lkcl.net>,
       James Morris <jmorris@redhat.com>, Stephen Tweedie <sct@redhat.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH][25/37] Clean up duplicate includes in mm/
Message-ID: <20070721164523.GA4043@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Jesper Juhl <jesper.juhl@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Rohland <hans-christoph.rohland@sap.com>,
	Christoph Rohland <ch.rohland@gmx.net>,
	Hugh Dickins <hugh@veritas.com>, Andi Kleen <ak@suse.de>,
	Luke Kenneth Casson Leighton <lkcl@lkcl.net>,
	James Morris <jmorris@redhat.com>, Stephen Tweedie <sct@redhat.com>,
	Rik van Riel <riel@redhat.com>
References: <200707211703.32870.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707211703.32870.jesper.juhl@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2007 at 05:03:32PM +0200, Jesper Juhl wrote:
> This patch cleans up duplicate includes in
> 	mm/
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

Looks sane to me, and builds fine.

Acked-by: Paul Mundt <lethal@linux-sh.org>
