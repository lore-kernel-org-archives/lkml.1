Return-Path: <linux-kernel-owner+w=401wt.eu-S1759402AbYCWKKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402AbYCWKKT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 06:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755454AbYCWKKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 06:10:05 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:54661 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241AbYCWKKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 06:10:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nicRqhFLJ195nyrEr21qjju893lhCgr3wGmc1WJJa5ZP9CN/HVP+fHr9Q/904H6J/iVkLCNu4IRwWiacvzRaTtbubRtNBprzEmPMwgLma8hpJBeG6vy3yveueP/U9Zpam2iGNdHUphaNzpIwLrRorzzQhA3cbMiircT8nvSjxbw=
Message-ID: <42212ce70803230310l446bff1cs33740a43d81eeb96@mail.gmail.com>
Date: Sun, 23 Mar 2008 11:10:02 +0100
From: "Marco Mangiante" <marco.mangiante@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [PROBLEM]: onda h600 express card don't work inside the elan u132 usb adapter
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <Pine.LNX.4.44L0.0803222208050.13906-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080322173147.d94740b7.akpm@linux-foundation.org>
	 <Pine.LNX.4.44L0.0803222208050.13906-100000@netrider.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alan,

> > > I want to use it with elan u132, an usb external adapter for
> > > UMTS-HSDPA express cards. In a document found on the net and written
> > > by Tony Olech (the author and maintainer of the elan u132 linux driver
> > > in Elan Digital Systems), I read that the device (u132) must load 2
> > > modules: the ftdi-u132 when it is plugged in the usb port, and the
> > > u132-hcd, when it recognize an express card inside it.
>
> As far as I know, the u132-hcd driver isn't being maintained by anybody
> except the author Tony Olech -- and maybe not even by him.

thanks for your response. This means that the elan u132 device is no
more supported because the u132-hcd is not supported? If not, what is
the substitute for it, if any exists?

-- 
Regards,

Marco Mangiante
