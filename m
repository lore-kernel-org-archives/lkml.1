Return-Path: <linux-kernel-owner+w=401wt.eu-S1759288AbXIJMaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288AbXIJMaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 08:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757969AbXIJMaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 08:30:08 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:43081 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757766AbXIJMaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 08:30:07 -0400
Date: Mon, 10 Sep 2007 13:30:05 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>, netdev@vger.kernel.org, rth@twiddle.net,
       dhowells@redhat.com, linux-mips@linux-mips.org
Subject: Re: [PATCH 1/2] remove asm/bitops.h includes
Message-ID: <20070910123005.GB10143@linux-mips.org>
References: <30483262301654323266@pripojeni.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30483262301654323266@pripojeni.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 08, 2007 at 09:00:08PM +0100, Jiri Slaby wrote:

> 
> remove asm/bitops.h includes
> 
> including asm/bitops directly may cause compile errors. don't include it
> and include linux/bitops instead. next patch will deny including asm header
> directly.
> 
> Cc: Adrian Bunk <bunk@kernel.org>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

For the MIPS and hamradio bits:

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
