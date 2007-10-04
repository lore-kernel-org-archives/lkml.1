Return-Path: <linux-kernel-owner+w=401wt.eu-S1761025AbXJDSSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761025AbXJDSSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 14:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757813AbXJDSSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 14:18:06 -0400
Received: from real.realitydiluted.com ([66.43.201.61]:57487 "EHLO
	real.realitydiluted.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756839AbXJDSSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 14:18:05 -0400
X-Greylist: delayed 2478 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Oct 2007 14:18:05 EDT
Date: Thu, 4 Oct 2007 12:39:28 -0500
From: "Steven J. Hill" <sjhill@realitydiluted.com>
To: veerasena reddy <veerasena_b@yahoo.co.in>
Cc: linux-mips <linux-mips@linux-mips.org>,
       "linux-kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: unresoved symbol _gp_disp
Message-ID: <20071004173928.GA32033@real.realitydiluted.com>
References: <230962.51223.qm@web8408.mail.in.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <230962.51223.qm@web8408.mail.in.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I have written a loadble module ( which gets complied
> along with kernel) which does some floating point
> operation.
>  
NO FLOATING POINT in the kernel PERIOD. Either use integer
operations, or redo your software architecture and do the
floating point in userspace.

-Steve
