Return-Path: <linux-kernel-owner+w=401wt.eu-S1752463AbXCHQXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbXCHQXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 11:23:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbXCHQXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 11:23:39 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:36181 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbXCHQXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 11:23:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nyYmizXN8Fn6IPMUKmPMde1g6Se+V28YYRIcg4beLi4AYN3HWiClRh/VFUe3CTyHqBvOPMKyyEqVbVgb0YezEpSHt3niIs8AE7uA4gJeJPcF7XxBpkD66SIaVP2uiqhvkvVXzsZXwcLsxBdtLHDrBswBV4LjDSDDUInrbekQsHU=
Message-ID: <6bffcb0e0703080823ybb4ceaasd229ba17cb2d40d6@mail.gmail.com>
Date: Thu, 8 Mar 2007 17:23:34 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: mm snapshot broken-out-2007-03-05-02-22.tar.gz uploaded
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Randy Cushman" <rcushman_linux@earthlink.net>,
       "Jaroslav Kysela" <perex@suse.cz>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Adrian Bunk" <bunk@stusta.de>
In-Reply-To: <s5hbqj3ohgb.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703051024.l25AOIF3015951@shell0.pdx.osdl.net>
	 <45EEA3C4.7000501@googlemail.com>
	 <20070307104746.f08a2e84.akpm@linux-foundation.org>
	 <6bffcb0e0703071141j42309702w793e4a76b1b23bfa@mail.gmail.com>
	 <20070307115024.756c848f.akpm@linux-foundation.org>
	 <s5hvehcrdod.wl%tiwai@suse.de> <45EF3B2C.9060801@googlemail.com>
	 <s5hfy8gbrmj.wl%tiwai@suse.de> <45F02EE2.6040606@googlemail.com>
	 <s5hbqj3ohgb.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/07, Takashi Iwai <tiwai@suse.de> wrote:
> At Thu, 08 Mar 2007 16:42:26 +0100,
> Michal Piotrowski wrote:
> >
> > > Also, it'd be helpful if you compare
> > > /proc/asound/card0/codec97#0/ac97#0-0+regs file before and after the
> > > patch.  This reveals which register bits differ actually.
> >
> > a2.txt is form 2.6.21-rc3 witchout 831466f4ad2b5fe23dff77edbe6a7c244435e973
>
> Just to make sure: it means that a2.txt is a working one and the
> anoter is non-working, right?

Right.

>
>
> Takashi
>

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
