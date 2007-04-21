Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278AbXDUWLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbXDUWLN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 18:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbXDUWLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 18:11:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46959
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753400AbXDUWK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 18:10:59 -0400
Date: Sat, 21 Apr 2007 15:10:52 -0700 (PDT)
Message-Id: <20070421.151052.78709111.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: tilman@imap.cc, linux-kernel@vger.kernel.org, kkeil@suse.de,
       i4ldeveloper@listserv.isdn4linux.de, akpm@linux-foundation.org
Subject: Re: [PATCH] Remove "obsolete" label from ISDN4Linux (v3)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070421215844.542d3aab@the-village.bc.nu>
References: <20070115172912.GA3323@pingi.kke.suse.de>
	<462A0CA7.2090908@imap.cc>
	<20070421215844.542d3aab@the-village.bc.nu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Sat, 21 Apr 2007 21:58:44 +0100

> On Sat, 21 Apr 2007 15:07:51 +0200
> Tilman Schmidt <tilman@imap.cc> wrote:
> 
> > From: Tilman Schmidt <tilman@imap.cc>
> > 
> > The "obsolete" label on the ISDN_I4L Kconfig option is not, and
> > has never been, accurate. It has already prompted repeated attempts
> > to remove actively used functionality from the kernel without a
> > working replacement. This patch removes the incorrect label and
> > corrects the accompanying help text.
> > 
> > Signed-off-by: Tilman Schmidt <tilman@imap.cc>
> 
> Nak-by: Alan Cox <alan@redhat.com>
> 
> If it isn't obsolete then fix the code to use the newer APIs as its about
> to end up && BROKEN let alone Obsolete. Make yourself maintainer and go
> for it.

This is my opinion too.

There is zero work being done on that subsystem to freshen it up
and make it current in any way.

Lack of a working replacement is not an argument for anything.
