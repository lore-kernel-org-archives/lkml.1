Return-Path: <linux-kernel-owner+w=401wt.eu-S1030694AbXDPOrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030694AbXDPOrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 10:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030721AbXDPOrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 10:47:16 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:20138 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030694AbXDPOrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 10:47:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=N5msGHWVzCaAcRaI71lnRwK7ZSXw+36u3bJc66zD88Ot9+JD2Ajd8vn8EVxr94UCicofaUPGR9hdt2uM5p9dn+x3i6NjPhoQ3M2Jm0JYBfew//sqMoe/bMJSbMIGRBS0vKjBR0v8GPCueJQ//IwmhPlZvO/uoR+MvCO3tsjf64Y=
Message-ID: <b6a2187b0704160747l2707cac8ifc480bdbf147c37b@mail.gmail.com>
Date: Mon, 16 Apr 2007 22:47:13 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: 4GB Physical. Less than 3GB in Linux.
Cc: linux-kernel@vger.kernel.org,
       "Fortier,Vincent [Montreal]" <Vincent.Fortier1@ec.gc.ca>
In-Reply-To: <46238572.5050203@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6a2187b0704160028x3f979dc3s1c9e18995f229782@mail.gmail.com>
	 <46238572.5050203@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/16/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> The X60 most certainly contains a chipset which severely limits the
> amount of accessible RAM due to issues with remapping of PCIe addresses.
>  Intel explains it somewhere on their web presence.  A quick & lazy web
> search turned this Intel paper up:
> http://www.polywell.com/us/support/faq/4GB_Rev1.pdf

Stefan,

That's interesting.Thanks for the pointer. I wondered if there's
anyone working on a patch for this.

I've seen this problem before, just like Vincent, I thought it's only
me. Didn't really bother me, until I got a new X60s with 4GB RAM.

Thanks,
Jeff.
