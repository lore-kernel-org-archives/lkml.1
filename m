Return-Path: <linux-kernel-owner+w=401wt.eu-S1758709AbZLIXYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709AbZLIXYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 18:24:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758680AbZLIXYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 18:24:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48786 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758676AbZLIXYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 18:24:47 -0500
Date: Thu, 10 Dec 2009 00:24:50 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Rudy Matela <rudy.matela@gmail.com>, Jan Yenya Kasprzak <kas@fi.muni.cz>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Coding style correction on some drivers that use Generic
 HDLC
In-Reply-To: <m33a3k9k2n.fsf@intrepid.localdomain>
Message-ID: <alpine.LNX.2.00.0912100024150.3755@pobox.suse.cz>
References: <20091209143540.GA9620@vacuum.larces.uece.br> <m33a3k9k2n.fsf@intrepid.localdomain>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Dec 2009, Krzysztof Halasa wrote:

> > Added a space separating some if/switch/while keywords from the following
> > parenthesis to conform to the CodingStyle.
> >
> > Signed-off-by: Rudy Matela <rudy.matela@gmail.com>
> > ---
> >
> >  drivers/net/wan/cosa.c       |   10 +++++-----
> >  drivers/net/wan/hdlc_cisco.c |    8 ++++----
> >  drivers/net/wan/hdlc_x25.c   |    4 ++--
> 
> Ack from me, though a subset may already be in David Miller's tree.
> Git merge can handle it without problems I guess.
> 
> Who is to commit this?

I will take care of it once the currently undergoing merging is done.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
