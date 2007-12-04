Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334AbXLDIfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbXLDIfd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 03:35:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbXLDIf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 03:35:26 -0500
Received: from elvis.franken.de ([193.175.24.41]:37213 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbXLDIf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 03:35:26 -0500
Date: Tue, 4 Dec 2007 09:25:35 +0100
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Andy Whitcroft <apw@shadowen.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] SC26XX: New serial driver for SC2681 uarts
Message-ID: <20071204082534.GA5938@alpha.franken.de>
References: <20071202194346.36E3FDE4C4@solo.franken.de> <20071203155317.772231f9.akpm@linux-foundation.org> <20071203155746.2dc4506d@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071203155746.2dc4506d@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2007 at 03:57:46PM -0800, Arjan van de Ven wrote:
> > > +#define SC26XX_MAJOR         204
> > > +#define SC26XX_MINOR_START   205
> > > +#define SC26XX_NR            2
> 
> did lanana assign these numbers officially?

I tried to numbers several months ago and didn't get any response :-(

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessary a
good idea.                                                [ RFC1925, 2.3 ]
