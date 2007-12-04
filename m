Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbXLDUi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbXLDUi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 15:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbXLDUh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 15:37:59 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:43757 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbXLDUh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 15:37:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=bH8/+50IkujKAfWOJfro/49VcoEwcct+hWOGswAzoDZ1ms9AI6OGTnQkmtdvDwd6yHh72uIP2a4cKvopUN2Y2vvHY5OA/3L9duouqtcKHkLZ77LrwqhPras6XLdZ4HPiR20EDTGe5bVg7AZBuQIIOhH3nHtgGAkF2zyyN6ByZAA=
Date: Tue, 4 Dec 2007 21:37:53 +0100
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: Re: Best way to detect CF id strings
Message-Id: <20071204213753.5e376d03.Kristoffer.ericson@gmail.com>
In-Reply-To: <20071204203038.20e7ca55@the-village.bc.nu>
References: <20071204201933.50d64f52.Kristoffer.ericson@gmail.com>
	<20071204203038.20e7ca55@the-village.bc.nu>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2007 20:30:38 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Tue, 4 Dec 2007 20:19:33 +0100
> Kristoffer Ericson <kristoffer.ericson@gmail.com> wrote:
> 
> > Greetings,
> > 
> > Usually I detect them by attaching CF->PCMCIA adapter to my laptop, but would much rather be able to use my usb-CF adapter.
> > This would also alot easier to explain to users which are having issues (unsupported/unknown id's).
> 
> What sort of "id" are we talking about here ?

Manufacturer and product id. Since the CF needs to be known to be used as an ide-cs device.
