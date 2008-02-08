Return-Path: <linux-kernel-owner+w=401wt.eu-S1756391AbYBHX2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbYBHX2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 18:28:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbYBHX1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 18:27:52 -0500
Received: from keil-draco.com ([216.193.185.50]:50857 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbYBHX1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 18:27:51 -0500
From: Daniel Hazelton <dhazelton@enter.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Date: Fri, 8 Feb 2008 18:27:39 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: David Newall <davidn@davidnewall.com>,
       Marcel Holtmann <marcel@holtmann.org>, Greg KH <greg@kroah.com>,
       Christer Weinigel <christer@weinigel.se>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20080125180232.GA4613@kroah.com> <200802081436.53928.dhazelton@enter.net> <20080208213637.7abe50a0@core>
In-Reply-To: <20080208213637.7abe50a0@core>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802081827.39984.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 February 2008 16:36:37 Alan Cox wrote:
> > In other words "EXPORT_SYMBOL_GPL" isn't his idea of "a good legal idea",
> > but people ignoring this and doing things that circumvent this will,
> > eventually, have problems with the people who hold the copyright on the
> > code. (In addition, he stated that circumventing the "EXPORT_SYMBOL_GPL"
> > bit might also be in violation of the DMCA, but he isn't sure if a court
> > would see it in the same light as someone cracking the CSS key on a DVD
> > expressly for the purpose of creating pirated copies)
>
> There was a good analysis of that argument on the list some time ago. I
> think the conclusion was fairly definitively no as the GPL explicitly
> gives the right to modify GPL code. You are therefore aready "authorised"
> to make such a change.
>
> It might have a significance in terms of intent but thats for lawyers to
> argue over.
>
> Alan

I think that's why he said he "Wasn't Sure" - as was pointed out in another 
post, the Lexmark ruling appears to apply for more than the "interface" 
portion of the ruling.

And Alan, while it might be legal to make the changes, making them for the 
sole purpose of using them in a proprietary module - when the people who 
actually hold the copyright have said "I think this is so core to the kernel 
that anything using it is a derivative work" - is what he thought *MIGHT* be 
legally actionable under the DMCA.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
