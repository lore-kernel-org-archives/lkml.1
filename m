Return-Path: <linux-kernel-owner+w=401wt.eu-S1758057AbXFSJK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057AbXFSJK7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 05:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407AbXFSJKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 05:10:52 -0400
Received: from mail2.ameuro.de ([195.140.232.8]:54774 "EHLO mail2.ameuro.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755182AbXFSJKv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 05:10:51 -0400
Date: Tue, 19 Jun 2007 11:10:40 +0200
From: Anders Larsen <al@alarsen.net>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
To: Alexandre Oliva <aoliva@redhat.com>
Cc: david@lang.hm, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <orbqfdavpn.fsf@oliva.athome.lsd.ic.unicamp.br> (from
	aoliva@redhat.com on Mon Jun 18 21:50:12 2007)
X-Mailer: Balsa 2.3.14
Message-Id: <1182244240l.11262l.0l@ecxwww1.reanet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
References: <orbqfdavpn.fsf@oliva.athome.lsd.ic.unicamp.br>
X-AEV-Kundenmail-Information: AEV Virus and Spam Secure Mail System
X-AEV-Kundenmail-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007-06-18 21:50:12, Alexandre Oliva wrote:
> Given the ROM exception in GPLv3, I guess you could seal and
> anti-tamper it as much as you want, and leave the ROM at such a place
> in which it's easily replaceable but with signature checking and all
> such that the user doesn't install ROM that is not authorized by you.

Sorry, I didn't state the regulations requirement clearly enough:

The manufacturer must be able to _remotely_ update the device
firmware, so as I see it (IANAL), Tivoisation _is_ a requirement.

Cheers
 Anders
