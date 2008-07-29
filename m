Return-Path: <linux-kernel-owner+w=401wt.eu-S1758361AbYG2Lzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361AbYG2Lzs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 07:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992AbYG2Lzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 07:55:38 -0400
Received: from mk-outboundfilter-4.mail.uk.tiscali.com ([212.74.114.32]:48777
	"EHLO mk-outboundfilter-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755935AbYG2Lzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 07:55:37 -0400
X-Trace: 116666863/mk-outboundfilter-2.mail.uk.tiscali.com/F2S/$F2S-NILDRAM-ACCEPTED/f2s-nildram-customers/195.149.44.6
X-SBRS: None
X-RemoteIP: 195.149.44.6
X-IP-MAIL-FROM: alistair@devzero.co.uk
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEEAPOhjkjDlSwG/2dsb2JhbACBW4lFpV8
X-IronPort-AV: E=Sophos;i="4.31,272,1215385200"; 
   d="scan'208";a="116666863"
X-IP-Direction: IN
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: 2.6.27-rc1: zd1211rw association fails
Date: Tue, 29 Jul 2008 12:55:33 +0100
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dsd@gentoo.org, kune@deine-taler.de, linux-wireless@vger.kernel.org
References: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org> <200807291225.00679.alistair@devzero.co.uk> <1217330777.10489.21.camel@johannes.berg>
In-Reply-To: <1217330777.10489.21.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807291255.33648.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 July 2008 12:26:17 Johannes Berg wrote:
> > If it doesn't strain you too much more, could you actually tell me where
> > this is? Your last 5 posts to LKML don't seem to contain such a patch,
> > and I'm not subscribed to linux-wireless.
>
> Well, the latter has archives.

Thanks for the patch, it fixes the issue for me with my zd1211rw. I hope 
the "100 million" rabid users that reported this can piss off happily with 
their working wireless. ;-)

(BTW thanks Hugh/Holger for the patch posting/link.)

-- 
Cheers,
Alistair.
