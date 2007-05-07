Return-Path: <linux-kernel-owner+w=401wt.eu-S967027AbXEGVzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967027AbXEGVzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 17:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966703AbXEGVzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 17:55:13 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:60088 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966729AbXEGVzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 17:55:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YRr2ku8tv2FUhF0NdbWaHY/HLst7zLW61Hrib11eSIYEJCr7zHnDJ46tdKZOR0pDTMgP2bz4wepTrwCqw1zBBMm27SpdZLfCBXtpebK9xuNEHyIbetzCoL4pKyH5BHue22W31Cx4Cwmc0tycxBDzYFZYdmt+GzP0DyhDJjsYeUg=
Message-ID: <d120d5000705071455y309e88ebt921331fdf30e60d2@mail.gmail.com>
Date: Mon, 7 May 2007 17:55:10 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 8/8] One Laptop Per Child power/battery driver
Cc: "Pavel Machek" <pavel@ucw.cz>, "David Woodhouse" <dwmw2@infradead.org>,
       "Anton Vorontsov" <cbou@mail.ru>, "Greg KH" <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       "Andrew Morton" <akpm@osdl.org>
In-Reply-To: <20070507222311.4589fc8a@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070503213303.GH20067@zarina> <20070507140453.GD3868@ucw.cz>
	 <1178550653.11851.191.camel@pmac.infradead.org>
	 <20070507194949.GB3981@ucw.cz>
	 <20070507222311.4589fc8a@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Mon, 7 May 2007 19:49:50 +0000
> Pavel Machek <pavel@ucw.cz> wrote:
>
> > On Mon 2007-05-07 16:10:53, David Woodhouse wrote:
> > > On Mon, 2007-05-07 at 14:04 +0000, Pavel Machek wrote:
> > > > Can we stick to ascii in sources?
> > >
> > > No. Please join us in the 21st century.
> >
> > We had this discussion before. Kernel sources should be us-ascii.
> > utf-8 is ok for documentation.
>
> We had this discussion before. Kernel sources should use utf-8 for
> comments where neccessary. Many names cannot be correctly represented in
> US ascii, and mangling them is just plain rude.

So should we all start writing our names in native alphabets? And comments too?

-- 
Dmitry
