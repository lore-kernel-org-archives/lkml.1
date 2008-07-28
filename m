Return-Path: <linux-kernel-owner+w=401wt.eu-S1756952AbYG1PW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952AbYG1PW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 11:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbYG1PWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 11:22:49 -0400
Received: from mk-outboundfilter-4.mail.uk.tiscali.com ([212.74.114.32]:41562
	"EHLO mk-outboundfilter-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752053AbYG1PWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 11:22:48 -0400
X-Trace: 116356869/mk-outboundfilter-2.mail.uk.tiscali.com/F2S/$F2S-NILDRAM-ACCEPTED/f2s-nildram-customers/195.149.44.6
X-SBRS: None
X-RemoteIP: 195.149.44.6
X-IP-MAIL-FROM: alistair@devzero.co.uk
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApwEAKyBjUjDlSwG/2dsb2JhbACBWok8o1k
X-IronPort-AV: E=Sophos;i="4.31,266,1215385200"; 
   d="scan'208";a="116356869"
X-IP-Direction: IN
From: Alistair John Strachan <alistair@devzero.co.uk>
To: "Justin Mattock" <justinmattock@gmail.com>
Subject: Re: NETDEV WATCHDOG: wifi0: transmit timed out
Date: Mon, 28 Jul 2008 16:22:43 +0100
User-Agent: KMail/1.9.9
Cc: "Arjan van de Ven" <arjan@infradead.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <dd18b0c30807280010h34002232wb53b7a154d9853fc@mail.gmail.com> <20080728061226.26ffae06@infradead.org> <dd18b0c30807280653q6c11cd6aia20946f6fd9acf0c@mail.gmail.com>
In-Reply-To: <dd18b0c30807280653q6c11cd6aia20946f6fd9acf0c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807281622.43288.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 July 2008 14:53:41 Justin Mattock wrote:
> On Mon, Jul 28, 2008 at 6:12 AM, Arjan van de Ven <arjan@infradead.org> 
wrote:
> > On Mon, 28 Jul 2008 00:10:46 -0700
> >
> > "Justin Mattock" <justinmattock@gmail.com> wrote:
> >> I should'nt be posting this, due to
> >> having  tainted modules(madwifi), but
> >
> > and fglrx
> >
> >> I figured I might as well:(below)
> >>
> >> [ 5000.986044] NETDEV WATCHDOG: wifi0: transmit timed out
> >
> > and what's more... it's the the wifi that's b0rked.
> >
> > sounds like you want to switch to ath5k or ath9k.
> >
> >
> > --
> > If you want to reach me at my work email, use arjan@linux.intel.com
> > For development, discussion and tips for power savings,
> > visit http://www.lesswatts.org
>
> If there's support for the 5418 card that the macbook pro has.
> interesting when lspci I'm not seeing the card number(below is lspci)
> As for the fglrx "f*&k it" too much of a pain.:

Yep check out the linux-wireless archives for more info, but ath9k is ready 
and working on your hardware. I've got a Macbook with the same chipset and 
it's totally fine (2.6.26+wireless-testing+ath9k).

-- 
Cheers,
Alistair.
