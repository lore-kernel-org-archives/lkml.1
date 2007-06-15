Return-Path: <linux-kernel-owner+w=401wt.eu-S1753034AbXFOIZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbXFOIZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 04:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbXFOIZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 04:25:48 -0400
Received: from canuck.infradead.org ([209.217.80.40]:58307 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbXFOIZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 04:25:46 -0400
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
From: David Woodhouse <dwmw2@infradead.org>
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
In-Reply-To: <200706142144.15695.dhazelton@enter.net>
References: <466A3EC6.6030706@netone.net.tr>
	 <200706132129.52736.dhazelton@enter.net>
	 <1181859896.5211.38.camel@shinybook.infradead.org>
	 <200706142144.15695.dhazelton@enter.net>
Content-Type: text/plain
Date: Fri, 15 Jun 2007 09:25:24 +0100
Message-Id: <1181895924.25228.319.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-14 at 21:44 -0400, Daniel Hazelton wrote:
> Agreed. I said I wasn't going to argue about it because there *ARE* 
> distinctions that the law makes and the GPL ignores. You can't have it both 
> ways. If the module is distributed *with* the kernel *SOURCE* then it doesn't 
> matter if it's a derivative work or not, because it becomes covered by the 
> kernels license. 

Yes.

> If it's distributed with the kernel *binaries* then it is 
> covered by its own license. In that case the only reason you'd have a right 
> to the source is if the module is considered a "derivative work".

Not necessarily. I'm not entirely sure where you got that idea from.

If the module is distributed 'as a separate work', _then_ what you say
is true: the only reason you'd have a right to the source is if the
module is considered a 'derivative work'.

But when you distribute the same module as part of a whole which is a
work based on the kernel, the distribution of the whole must be on the
terms of GPL, whose permissions for other licensees extend to the entire
whole, and thus to each and every part regardless of who wrote it.

The words you used were 'with the kernel', which could actually mean
either of the above. In the case of embedded Linux-based firmware
though, it's definitely the latter. It's a coherent whole, and it
contains both the kernel and the module. Thus the GPL extends to each
and every part, regardless of who wrote it. Including the module.

-- 
dwmw2

