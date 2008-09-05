Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbYIEONp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbYIEONp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 10:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbYIEONh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 10:13:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:48262 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbYIEONh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 10:13:37 -0400
Date: Fri, 5 Sep 2008 07:13:37 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Bernd Schubert <bs@q-leap.de>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: frame unwinder patches
Message-ID: <20080905071337.3373ab86@infradead.org>
In-Reply-To: <200809051552.47929.bs@q-leap.de>
References: <g9p3du$n95$1@ger.gmane.org>
	<200809051119.21699.bs@q-leap.de>
	<20080905063317.5e3a2b2c@infradead.org>
	<200809051552.47929.bs@q-leap.de>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2008 15:52:47 +0200
Bernd Schubert <bs@q-leap.de> wrote:
> >
> > (and if you really care it's 1 line of code to turn it off)
> 
> It is not only this, I think the dwarf2 stack unwinder patches
> provide by far better traces than the in-kernel unwinder. At least
> ever since I applied these patches to our kernels, I was able to read
> the stack dumps...
> 

they really wouldn't be different than the ones you get if you remove
the "?" lines.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
