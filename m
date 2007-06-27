Return-Path: <linux-kernel-owner+w=401wt.eu-S1762662AbXF0Utc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762662AbXF0Utc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 16:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbXF0UtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 16:49:25 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55440 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754644AbXF0UtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 16:49:24 -0400
Date: Wed, 27 Jun 2007 13:49:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] balance parenthesis in serial core
Message-Id: <20070627134912.b1c5c428.akpm@linux-foundation.org>
In-Reply-To: <1182976958.19006.50.camel@shinybook.infradead.org>
References: <200706271030.l5RAUgKE015163@imap1.linux-foundation.org>
	<200706272222.01300.m.kozlowski@tuxland.pl>
	<20070627133717.d19d82c9.akpm@linux-foundation.org>
	<1182976958.19006.50.camel@shinybook.infradead.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007 21:42:38 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> On Wed, 2007-06-27 at 13:37 -0700, Andrew Morton wrote:
> > Thanks.  so...  why shouldn't we just remove the buggy&&unused
> > RELEVANT_CFLAG defines??
> 
> I was just about to suggest that. I originally intended to use them for
> the obvious purpose, but then realised that we can just rely on the
> integers i_speed and o_speed instead.

OK.

> Do you want a replacement/incremental patch?

I'll take care of it, thanks.
