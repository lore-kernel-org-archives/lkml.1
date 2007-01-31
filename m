Return-Path: <linux-kernel-owner+w=401wt.eu-S1030583AbXAaVM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030583AbXAaVM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 16:12:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030584AbXAaVM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 16:12:28 -0500
Received: from an-out-0708.google.com ([209.85.132.250]:8539 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030583AbXAaVM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 16:12:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CoYWD8lGiO4gvAFAjPW6Wv8D5LNcZ8withGOOYe6FzFksrBVCMXbIAC1aGsk9dGyUX5WqTX6aeNDNGx5IpkAQUQJLsH0idOLvKkpgI18Sdg9GQc6bkeiThvbtgwDIA/FnpdMaYfIy9MvRKLyHmEmE16Xei3PHFgejSPzsIAAY60=
Message-ID: <512afbf90701311312k126e0b2ag85ca18c2dd470dbf@mail.gmail.com>
Date: Wed, 31 Jan 2007 13:12:26 -0800
From: "Kristen Accardi" <kristen.kml@gmail.com>
To: wsl3@lrsehosting.com
Subject: Re: Unidentified Intel wifi network card
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       alan@redhat.com
In-Reply-To: <1170264624.5569.15.camel@scott-640m>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1170264624.5569.15.camel@scott-640m>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/31/07, Scott Lockwood <lkml@lrsehosting.com> wrote:
> I'm looking for assistance with a wifi device I can't find a driver for,
> the Intel Wireless 3945.
>
> I"m getting this:
>
> 0000:0c:00.0 Network controller: Intel Corporation: Unknown device 4222
> (rev 02)
>
> on a new Dell Latitude D820. Anyone know if there will be an open source
> driver for this any time soon, or if there is one now?
>
> I'm using the latest vendor supplied kernel, so my apologies if this has
> already been done and I'm late to the party. I wasn't able to find much,
> other than 'use the NDIS wrapper' which I really don't want to do.
>
> Thanks for any assistance, at all,
> Scott
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

If you want to play with the experimental version with no binary
regulatory daemon,
try here:
http://bughost.org/iwlwifi/

Otherwise, go here:
http://ipw3945.sf.net
