Return-Path: <linux-kernel-owner+w=401wt.eu-S1759829AbXIMPPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759829AbXIMPPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 11:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755800AbXIMPO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 11:14:58 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:38356 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbXIMPO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 11:14:57 -0400
Date: Thu, 13 Sep 2007 16:14:52 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, Andrew Morton <akpm@linux-foundation.org>,
       netdev@vger.kernel.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sb1250-mac.c: De-typedef, de-volatile, de-etc...
Message-ID: <20070913151452.GB29665@linux-mips.org>
References: <Pine.LNX.4.64N.0709101310030.25038@blysk.ds.pg.gda.pl> <46E8B56E.7060705@pobox.com> <Pine.LNX.4.64N.0709131506040.31069@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64N.0709131506040.31069@blysk.ds.pg.gda.pl>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 03:13:06PM +0100, Maciej W. Rozycki wrote:

>  Hmm, works fine with linux-2.6.git#master.  I do not recall any recent 
> activity with this driver -- I wonder what the difference is.  Let me 
> see...

Hmm...  HEAD du jour has no differences for the sb1250-mac between lmo
and kernel.org.

  Ralf
