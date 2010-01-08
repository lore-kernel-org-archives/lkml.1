Return-Path: <linux-kernel-owner+w=401wt.eu-S1752931Ab0AHRkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab0AHRkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 12:40:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798Ab0AHRkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 12:40:35 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:64936 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab0AHRke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 12:40:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=iRRDbXxtEAvXJw/TtWKv68Mwxsy3K98Q7bguZl6AK3Z34hJUaVb29SdAFUgeJ8KKiW
         QtzVjBZ1GY/NVZMPo3OqlLyZtyczyCnzazYmgBfye0x1HuxRdrPNa4GeHEXsmHAmacuX
         l66w35PWofXu729TF4AgA/Z7mxnd4seIXNdFE=
Subject: Re: RFC: [PATCH V2 0/9 Integration of SmartMedia/xD into mtd
 subsystem
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mtd <linux-mtd@lists.infradead.org>, Alex Dubov <oakad@yahoo.com>
In-Reply-To: <20100108160404.GE31872@logfs.org>
References: <1262963092.12577.14.camel@maxim-laptop>
	 <20100108160404.GE31872@logfs.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jan 2010 19:40:29 +0200
Message-ID: <1262972429.20060.4.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-08 at 17:04 +0100, Jörn Engel wrote: 
> On Fri, 8 January 2010 17:04:52 +0200, Maxim Levitsky wrote:
> > 
> > * Write speed is of course still very low, but like I said, it might be
> > hardware problem.
> 
> Iirc the alauda could do about 400kB/s.  Speed didn't change noticeably
> between 16M and 256M cards.  My conclusion back then was to blame the
> alauda chip.  If you get even less, the problem likely isn't in the
> cards but in the reader and/or your driver.
Who knows...
Like I said, I get around 330 Kbytes/s in card reader integrated in
printer. It is still much higher that what I get with this driver....

I will figure that out sooner or later.

Btw, your cards aren't Type M, right?
However I use here a Type M card, and its likely to include an FTL
inside, thus, it might explain the low speeds I get there partially...

Best regards,
Maxim Levitsky

