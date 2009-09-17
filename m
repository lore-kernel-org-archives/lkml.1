Return-Path: <linux-kernel-owner+w=401wt.eu-S1758734AbZIQRrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734AbZIQRrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 13:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755233AbZIQRrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 13:47:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:44366 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468AbZIQRri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 13:47:38 -0400
Date: Thu, 17 Sep 2009 19:47:25 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Scott James Remnant <scott@canonical.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Kay Sievers <kay.sievers@vrfy.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartmann <greg@kroah.com>
Subject: Re: [PATCH] Remove broken by design and by implementation devtmpfs
 maintenance disaster
Message-ID: <20090917194725.355b761c@infradead.org>
In-Reply-To: <1253205332.4718.9.camel@quest>
References: <m1y6oef08k.fsf@fess.ebiederm.org>
	<ac3eb2510909170503n1da43ea0u7c900f2f6f647fdc@mail.gmail.com>
	<20090917141303.428fe73c@lxorguk.ukuu.org.uk>
	<1253205332.4718.9.camel@quest>
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

On Thu, 17 Sep 2009 17:35:32 +0100
Scott James Remnant <scott@canonical.com> wrote:

> On Thu, 2009-09-17 at 14:13 +0100, Alan Cox wrote:
> 
> > > >  * A static dev is faster.
> > > 
> > > A static /dev is unreliable and unpredictable, and can not be
> > > used in any not very limited and controlled environment. It's
> > > pure theory for
> > 
> > Moblin appears to be the fastest boot and doesn't use it. I fact
> > Arjan seems pretty anti
> > 
> And of the "ordinary" distros, Ubuntu has the fastest boot and we are
> very keen to use devtmpfs, and I am very pro.

personally I consider Moblin an ordinary distro. 


> 
> I don't really see the issue here.  If Arjan doesn't want to use
> devtmpfs for Moblin, he doesn't have to.

my biggest objection was to the use of boot time as argument.
That was and still is deceiving and false. There may be other arguments
for devfs, but I'm not going to get in the middle of those. But boot
time isn't it.

I do share frustration with Eric on how Kay and Greg have handled this.
It really felt like a combination of bullying, ignoring any contrarian
argument and just ramming stuff down. Not at all unlike the original
devfs fiasco. It has left me with a pretty bad taste in my mouth and
am pretty disappointed; I expected better.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
