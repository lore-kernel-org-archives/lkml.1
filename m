Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbXJWR5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbXJWR5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 13:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbXJWR5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 13:57:37 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:45318 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbXJWR5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 13:57:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eiGrG6RHoiqkX4h/J6DHmMp5hQxqFz4yp2QGPzK2bLu1TD9JfA1ULIaQLJQpYe/muBjpZm6+lfPgXkLvB+APlxD5WGfcMTjW4nh0Xr9C7liiXU/sy2MVA6Rgjij0hoY4xwfR8tJKGW67VPcZZnJA/mA9jTPJ2AxFjT9v7Y4TPsQ=
Message-ID: <9e0cf0bf0710231057lf60ce17ldd38489850cdf7c5@mail.gmail.com>
Date: Tue, 23 Oct 2007 19:57:34 +0200
From: "Alon Bar-Lev" <alon.barlev@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [BUG] rfcomm]
Cc: linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net
In-Reply-To: <1193162106.6184.208.camel@violet>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710231950.31313.alon.barlev@gmail.com>
	 <1193162106.6184.208.camel@violet>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/07, Marcel Holtmann <marcel@holtmann.org> wrote:
> first of all, please check if this still happens with 2.6.23, because we
> had some patches in the area of the RFCOMM TTY code that might have
> fixed this.

These messages are of 2.6.23.

> Second, can you try without uswsusp or suspend2. Both of
> them are not upstream and I can't tell how much these would effect this
> kind of behavior.

How can I test this without doing suspend?
uswsusp is not upstream?!?! Rafael?

Best Regards,
Alon Bar-Lev.
