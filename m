Return-Path: <linux-kernel-owner+w=401wt.eu-S1759426AbXFNBkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426AbXFNBkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 21:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757606AbXFNBjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 21:39:55 -0400
Received: from bee.hiwaay.net ([216.180.54.11]:50961 "EHLO bee.hiwaay.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756131AbXFNBjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 21:39:54 -0400
X-Greylist: delayed 458 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jun 2007 21:39:54 EDT
Date: Wed, 13 Jun 2007 20:32:14 -0500
From: Chris Adams <cmadams@hiwaay.net>
To: linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070614013214.GA1124293@hiwaay.net>
References: <fa.khBgzvPDXYj45cntZBDPf6OM0jQ@ifi.uio.no> <fa.yLrgAnyZNUTaQtIdBjBq6aFGXU8@ifi.uio.no> <fa.OeLmE9apDSUc1Jj/3NNi3Oh5dxg@ifi.uio.no> <fa.81ogjXw6CW1aVETJQcz/2q97Mlw@ifi.uio.no> <fa.1pq8pRNsm/jhYV6tXEtGFJB8M+0@ifi.uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <or8xanl8jg.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Once upon a time, Alexandre Oliva  <aoliva@redhat.com> said:
>  if you distribute copies of such a program, [...]
>  you must give the recipients all the rights that you have
>
>So, TiVo includes a copy of Linux in its DVR.  
>
>TiVo retains the right to modify that copy of Linux as it sees fit.
>
>It doesn't give the recipients the same right.

Sure it does; you received a program (the kernel) and you can modify it.
You also received hardware; they don't support modification of that.
Nowhere in the license does it say they have to, because the license
only covers the program.

Or are you claiming that putting software on hardware makes the result a
derivative work?  I think it falls under the "mere aggregation" clause.

What if TiVo had put the kernel in a burned-in ROM (not flash, or on a
flash ROM with no provision for reprogramming it)?  Would that also
violate the "spirit" of the GPL?  Must any device that wishes to include
GPL code include additional hardware to support replacing that code
(even if that hardware is otherwise superfluous)?
