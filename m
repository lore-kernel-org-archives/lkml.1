Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbYBHTJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbYBHTJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 14:09:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYBHTIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 14:08:50 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54506 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbYBHTIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 14:08:48 -0500
Date: Fri, 8 Feb 2008 11:13:19 -0800
From: Greg KH <greg@kroah.com>
To: David Newall <davidn@davidnewall.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Christer Weinigel <christer@weinigel.se>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Message-ID: <20080208191319.GB12625@kroah.com>
References: <84144f020802030743j1278ac64j2ee3e2cbc5c3fefc@mail.gmail.com> <47A5E67D.9040804@davidnewall.com> <84144f020802030848v160253feoa24c5ecefc7c91f5@mail.gmail.com> <courier.47A8497B.0000472E@hawking.rebel.net.au> <1202240590.15090.119.camel@violet> <47AB0A76.3000404@davidnewall.com> <1202411113.15090.263.camel@violet> <47ABD317.5060805@davidnewall.com> <1202462101.15090.300.camel@violet> <47ACA204.7030702@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47ACA204.7030702@davidnewall.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2008 at 05:10:04AM +1030, David Newall wrote:
> The reasonable conclusion is that an original, non-derivative USB driver
> can be written, and let's face it, a number of them have been referred
> to in the course of this discussion.

A "driver" is not an "application" as you tried to reference in your
prior quotes.  It is a tiny portion of the whole kernel, and as such,
does fall under the derivative works portion when it is run within the
Linux kernel.

So the comparison is quite different, sorry.

Again, see the Samba decisions that have happened in the past when
companies have tried to add modules to it that are not under the GPL.
They have failed every single time, so there is a lot of precedent for
this kind of thing.

And again, this is not just my opinion.  It is the legal opinion my
lawyers and the lawyers of many large companies who deal with Linux
every day.

If you wish to disagree with this, fine.  Consult with your own lawyer
and make up your own mind.

lkml and linux-usb is not for legal discussions, that's like asking
lawyers for medical advice, you might get some good opinions, but then
again, you can get a lot of crackpot ideas.

This is going to be my last response on this thread,

greg k-h
