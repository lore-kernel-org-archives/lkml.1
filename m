Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbYHEOGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbYHEOGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 10:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbYHEOGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 10:06:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:42534 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbYHEOGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 10:06:08 -0400
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface
	for on access scanning
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Paris <eparis@redhat.com>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080805123136.0073e52f@lxorguk.ukuu.org.uk>
References: <1217883616.27684.19.camel@localhost.localdomain>
	 <20080804223249.GA10517@kroah.com> <20080805002618.GA18215@infradead.org>
	 <1217897224.27684.66.camel@localhost.localdomain>
	 <20080805005415.GA10108@infradead.org>
	 <20080805123136.0073e52f@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 05 Aug 2008 16:06:04 +0200
Message-Id: <1217945164.3589.128.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-05 at 12:31 +0100, Alan Cox wrote:
> > No, I want a sane security policy in kernelsapce that doesn't look
> > at the content because doing security by content properly is equivalent
> > to solving the halting problem.  I couldn't give a rats a** about
> > windows viruses as they can't actually cause any harm on a Linux
> > machine.
> 
> Go on then.. post patches.
> 
> I think your are being incredibly naïve. Our memory debugging is not 100%
> solid but work by heuristic. Our lock analysis doesn't solve the halting
> problem but is extremely useful and so on.

Sure, but what's the point of partial security? It seems to me you're
not secure until you're fully secure, so why bother with almost?

Every bug caught with the debuggers is one caught, yay :-)

Every virus let through is a pawned system, aww :-(



