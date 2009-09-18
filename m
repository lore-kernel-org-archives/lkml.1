Return-Path: <linux-kernel-owner+w=401wt.eu-S1752038AbZIROZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbZIROZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 10:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbZIROZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 10:25:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:35000 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbZIROZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 10:25:06 -0400
Date: Fri, 18 Sep 2009 16:25:03 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartmann <greg@kroah.com>
Subject: Re: [PATCH] Remove broken by design and by implementation devtmpfs
  maintenance disaster
Message-ID: <20090918162503.6735cc1b@infradead.org>
In-Reply-To: <ac3eb2510909180711k223aeb6ena2de3645317d03bd@mail.gmail.com>
References: <m1y6oef08k.fsf@fess.ebiederm.org>
	<ac3eb2510909170503n1da43ea0u7c900f2f6f647fdc@mail.gmail.com>
	<m1d45oxsrk.fsf@fess.ebiederm.org>
	<20090918160944.58e5c1f5@infradead.org>
	<ac3eb2510909180711k223aeb6ena2de3645317d03bd@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Sep 2009 16:11:16 +0200
Kay Sievers <kay.sievers@vrfy.org> wrote:

> On Fri, Sep 18, 2009 at 16:09, Arjan van de Ven <arjan@infradead.org>
> wrote:
> 
> > frankly, modprobe should call the settle.
> 
> We call modprobe from udev, and will have fun with such a solution.
> 

too bad you cut my next sentence which said that there needed to be a
way to opt out of that.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
