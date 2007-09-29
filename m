Return-Path: <linux-kernel-owner+w=401wt.eu-S1754949AbXI2FPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbXI2FPo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 01:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbXI2FPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 01:15:35 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36085 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbXI2FPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 01:15:34 -0400
Message-ID: <46FDDF52.1020607@pobox.com>
Date: Sat, 29 Sep 2007 01:14:58 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Ralf Baechle <ralf@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sb1250-mac.c: De-typedef, de-volatile, de-etc...
References: <Pine.LNX.4.64N.0709101310030.25038@blysk.ds.pg.gda.pl> <46E8B56E.7060705@pobox.com> <Pine.LNX.4.64N.0709131506040.31069@blysk.ds.pg.gda.pl> <20070913151452.GB29665@linux-mips.org> <46E95C7F.1050302@pobox.com> <Pine.LNX.4.64N.0709141135290.1926@blysk.ds.pg.gda.pl> <46F1F2CE.7020300@pobox.com> <Pine.LNX.4.64N.0709201354320.30788@blysk.ds.pg.gda.pl> <46F2A779.2040904@pobox.com> <Pine.LNX.4.64N.0709201829290.30788@blysk.ds.pg.gda.pl>
In-Reply-To: <Pine.LNX.4.64N.0709201829290.30788@blysk.ds.pg.gda.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
>  Remove typedefs, volatiles and convert kmalloc()/memset() pairs to
> kcalloc().  Also reformat the surrounding clutter.
> 
> Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
> ---
> On Thu, 20 Sep 2007, Jeff Garzik wrote:
> 
>> Remove the "linux-" prefix.
> 
>  Hmm, it looks like a bad application of `sed' by myself.  Sorry for the 
> noise.
> 
>   Maciej

applied


