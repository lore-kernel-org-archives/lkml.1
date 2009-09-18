Return-Path: <linux-kernel-owner+w=401wt.eu-S1755066AbZIRMyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbZIRMyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 08:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbZIRMyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 08:54:23 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:55498 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbZIRMyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 08:54:23 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Bart Hartgers <bart.hartgers@gmail.com>
Subject: Re: New ark3116 driver - how to get included into kernel?
Date: Fri, 18 Sep 2009 14:55:51 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc9-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ondrej Zary <linux@rainbow-software.org>,
       ark3116_driver@auctionant.de
References: <7eb6a4d80909170549k7a19eb01s8975fe2c5f230cee@mail.gmail.com> <20090918061529.GB7717@kroah.com> <7eb6a4d80909180515k48ee2197q8f6e5ff8933c4647@mail.gmail.com>
In-Reply-To: <7eb6a4d80909180515k48ee2197q8f6e5ff8933c4647@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909181455.51909.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 18. September 2009 14:15:57 schrieb Bart Hartgers:
> > That's the preferred method, I'd like to not drop the existing one if at
> > all possible.
>
> Do you think it is worth the effort to minimize the diff, or should I
> just replace ark3116.c by ark3116new.c?

The important part is not the size but the clarity of the diff.

	Regards
		Oliver

