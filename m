Return-Path: <linux-kernel-owner+w=401wt.eu-S1761356AbYBLIdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761356AbYBLIdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 03:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbYBLIdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 03:33:38 -0500
Received: from mk-outboundfilter-4.mail.uk.tiscali.com ([212.74.114.32]:22114
	"EHLO mk-outboundfilter-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752659AbYBLIdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 03:33:38 -0500
X-Trace: 4632612/mk-outboundfilter-2.mail.uk.tiscali.com/F2S/$ACCEPTED/freedom2Surf-customers/83.67.11.44
X-SBRS: None
X-RemoteIP: 83.67.11.44
X-IP-MAIL-FROM: tvrtko@ursulin.net
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAE7osEdTQwss/2dsb2JhbACrRQ
X-IP-Direction: IN
From: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: One minute delay when booting 2.6.24.1
Date: Tue, 12 Feb 2008 08:33:37 +0000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
       Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
References: <200802091329.35851.tvrtko@ursulin.net> <Pine.LNX.4.64.0802092301180.6917@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0802092301180.6917@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802120833.37955.tvrtko@ursulin.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 February 2008 22:01:44 Jan Engelhardt wrote:
> On Feb 9 2008 13:29, Tvrtko A. Ursulin wrote:
> >Hi all,
> >
> >As the subject says I get ~1 minute delay when booting 2.6.24.1
> >pretty reliably. It is possible it is not new to 2.6.24.1 but I
> >can't tell due recent hardware changes.
> >
> >dmesg excerpt where it happens looks like this (full one attached):
>
> Do you really experience a 1 minute wait, or is this perhaps
> just the clock skipping?

This seemed to slipped everyone's attention so I took the liberty of copying a 
couple of you guys. I don't know better than to guess it could something to 
do with timers or scheduling so apologies if you are not the right people.

As said in my previous reply it is a real ~60 second delay early in the boot 
process with some logs attached in my initial report.

Thanks,

Tvrtko
