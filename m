Return-Path: <linux-kernel-owner+w=401wt.eu-S1751437AbYBJNpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437AbYBJNpw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 08:45:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750781AbYBJNpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 08:45:44 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:16157 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbYBJNpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 08:45:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UsSccZ6lA/SAu3uoV389Uw2OV8UNseBOFrmac35mkURx7N4zCc1YPPpAcHzW/tzbHFFJ2f+X2u96r5VPvMFvynzAgTtX06lfM8DRM9TrsEZQhYLtT/HVn3l9ZG0lz2vyoOKDZkLgsvvb45MiWu659TurKF+IlddBsfbg+WnuJJg=
Message-ID: <4ad95d220802100545x181f0c1erc9025fc76e7f3b34@mail.gmail.com>
Date: Sun, 10 Feb 2008 14:45:42 +0100
From: "Olof Johansson" <olof.j.johansson@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Marcel Holtmann" <marcel@holtmann.org>, davids@webmaster.com,
       "David Newall" <davidn@davidnewall.com>, "Greg KH" <greg@kroah.com>,
       "Christer Weinigel" <christer@weinigel.se>, linux-usb@vger.kernel.org
In-Reply-To: <200802100830.37987.dhazelton@enter.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <MDEHLPKNGKAHNMBLJOLKGEJHKDAC.davids@webmaster.com>
	 <200802100007.50441.dhazelton@enter.net>
	 <20080210112045.0035457c@core>
	 <200802100830.37987.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2008, Daniel Hazelton <dhazelton@enter.net> wrote:
>
> Yes, of course, and I'll never argue otherwise. However, what I was saying is
> that it is the claim of the FSF that, in no uncertain terms, a C program that
> uses the standard C library interface and is linked to glibc instead of, say,
> the old Borland libc, is automatically GPL because it's been linked to GPL
> code.
>
glibc is LGPL and will not force you to use GPL.
