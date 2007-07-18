Return-Path: <linux-kernel-owner+w=401wt.eu-S1764899AbXGRGgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764899AbXGRGgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 02:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbXGRGgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 02:36:08 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:5497 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbXGRGgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 02:36:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rT1YpPX5XjA0MuLI3Wt5FrfpOBuE79YVopx7/fuuCBPd6VW/+dC55l52Sa+zlVKnd+S2fO6W8wPzIcKoX2uYuTXHPvRxOu1z9f+nVCTLk+jDlQmdsMCa1KYVk3c+CR6wiTFeg+TnPS3bUmDkLpzIYCw1L9NnvoGj2jkZnlArevc=
Message-ID: <dcf706c60707172336u38cb87c4ia77cc4dbe9b38a56@mail.gmail.com>
Date: Wed, 18 Jul 2007 08:36:05 +0200
From: "Sasa Ostrouska" <casaxa@gmail.com>
To: "Daniel Drake" <dsd@gentoo.org>
Subject: Re: VESAFB CUSTOM RESOLUTION
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <469D71FB.5070408@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dcf706c60707170713t605ce652r83b5b53f3c315691@mail.gmail.com>
	 <469D71FB.5070408@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/18/07, Daniel Drake <dsd@gentoo.org> wrote:
> Sasa Ostrouska wrote:
> > I want to ask one question about a custom resolution in the console.
> > I have a Sony Vaio Laptop VGN-SZ2VP/X, the screen resolution is
> > 1280x800, now I'm using the vga=773 which is an 1024x768 but this is
> > ugly as I get a border of about 2-3cm on one the sides of the screen.
> > So is there a way that I set the 1280x800 resolution at boot time ?
>
> I don't think vesafb can do what you want. However, uvesafb probably can.
>
> http://dev.gentoo.org/~spock/projects/uvesafb/
>
> Daniel

Daniel you seem to be right, as till now, no one of those solutions
for me worked, I always end up or with a non recognised option or a
small square 640x480 pixels where I see the console. I need to try
still the vbetest thing what Mr. Daplas proposed.

In any case this laptop has an screen of 16:10 aspect ratio and I
belive would be good
to have those modes in the vesafb driver.

Rgds
Sasa
