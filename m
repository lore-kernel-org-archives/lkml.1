Return-Path: <linux-kernel-owner+w=401wt.eu-S932530AbXGOAJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530AbXGOAJr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 20:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760706AbXGOAJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 20:09:40 -0400
Received: from lixom.net ([66.141.50.11]:42462 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759844AbXGOAJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 20:09:39 -0400
Date: Sat, 14 Jul 2007 19:21:49 -0500
From: Olof Johansson <olof@lixom.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dougthompson@xmission.com, greg@kroah.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, Egor Martovetsky <egor@pasemi.com>
Subject: Re: [PATCH 3/8] drivers edac new pasemi driver
Message-ID: <20070715002149.GA21539@lixom.net>
References: <4697adf6.ml1pGGjvWEkYBXbh%dougthompson@xmission.com> <20070713113641.52157b67.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713113641.52157b67.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 11:36:41AM -0700, Andrew Morton wrote:
> On Fri, 13 Jul 2007 10:53:10 -0600
> dougthompson@xmission.com wrote:
> 
> > +			edac_mc_printk(mci, KERN_ERR,
> > +				       "Unrecognized Rank Config\n");
> 
> If this message ever comes out, you're gonna say "argh, I wish I'd printed
> rankcfg".
> 
> Do you want to do this??

Yes. Thanks.

Acked-by: Olof Johansson <olof@lixom.net>

