Return-Path: <linux-kernel-owner+w=401wt.eu-S1759472AbXFRJXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472AbXFRJXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 05:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756729AbXFRJXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 05:23:42 -0400
Received: from mail2.ameuro.de ([195.140.232.8]:57682 "EHLO mail2.ameuro.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634AbXFRJXl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 05:23:41 -0400
X-Greylist: delayed 1995 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Jun 2007 05:23:41 EDT
Date: Mon, 18 Jun 2007 10:49:56 +0200
From: Anders Larsen <al@alarsen.net>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Balsa 2.3.14
Message-Id: <1182156596l.29108l.0l@ecxwww1.reanet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-AEV-Kundenmail-Information: AEV Virus and Spam Secure Mail System
X-AEV-Kundenmail-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Jun 2007 22:54:56 -0300, Alexandre Oliva wrote:

> I don't know any law that requires tivoization.

Not exactly laws, but pretty close:

Credit-card payment terminals are subject to strict security
certification, where it has to be ensured that

a) the user cannot tinker with the device without rendering it unusable
for its original purpose (electronic payments), and

b) the manufacturer is able to update the device _in_ _the_ _field_.

Those are hard requirements imposed by the banks and credit-card companies.

We _are_ allowed to disclose the source code (and we do, of course) so
that it can be used for other purposes, and of course the user can modify
it. But there's just no way she would be (legally) able to run the
modified software in the same device for the original purpose.

With the (current draft of) GPLv3 we could not legally use Linux on such
devices.

Cheers
 Anders


