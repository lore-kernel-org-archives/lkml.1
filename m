Return-Path: <linux-kernel-owner+w=401wt.eu-S1758065AbXFNWYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbXFNWYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbXFNWYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:24:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34542 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbXFNWYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:24:44 -0400
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
From: David Woodhouse <dwmw2@infradead.org>
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
In-Reply-To: <200706132129.52736.dhazelton@enter.net>
References: <466A3EC6.6030706@netone.net.tr>
	 <200706131946.15714.dhazelton@enter.net>
	 <20070614021619.381331dc@the-village.bc.nu>
	 <200706132129.52736.dhazelton@enter.net>
Content-Type: text/plain
Date: Thu, 14 Jun 2007 23:24:55 +0100
Message-Id: <1181859896.5211.38.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-13 at 21:29 -0400, Daniel Hazelton wrote:
> Agreed. However, AFAICT, TiVO meets the provisions of the GPLv2 - they make 
> the source of the GPL'd part of their system available. (And I'm not going to 
> get into arguments over whether kernel modules are "derivative works" or not, 
> since those invariably end up with "They aren't, even though we think they 
> should be")

Who cares about whether the module is a derivative work? That's only
relevant when you distribute the module as a separate work. When you
ship a combined work including both the kernel and the module in
question, it's a _whole_ lot easier to interpret the GPL.

-- 
dwmw2

