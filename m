Return-Path: <linux-kernel-owner+w=401wt.eu-S1756294AbYJ3AiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294AbYJ3AiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 20:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbYJ3Ahz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 20:37:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:35914 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbYJ3Ahz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 20:37:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gv7E5ng6kuUODeywBzss0c2fIkBNRVw8cKN9xH26qBF+g/jV8ArLVtstUb0UdmnLPP
         szqOOaN7PIRRcMzPt8ANxWj870zkRW36a3A0iq7ZldjUO65Oj22KPDfiH28abRMujbLd
         NDIZ3AI4Gy7CxntQPKPiJjPhThl3KNuFVzZNk=
Message-ID: <3aaafc130810291737i41716bd2r767150b47239b0a1@mail.gmail.com>
Date: Wed, 29 Oct 2008 20:37:54 -0400
From: "J.R. Mauro" <jrm8005@gmail.com>
To: "Moritz Muehlenhoff" <jmm@debian.org>
Subject: Re: staging: me4000 and relation to other data acquisition devices
Cc: linux-kernel@vger.kernel.org, "Greg KH" <gregkh@suse.de>
In-Reply-To: <slrngghcgf.3do.jmm@inutil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081028154918.GA5630@mediacenter> <20081028163456.GA4278@suse.de>
	 <20081028103337.a021e85d.rdunlap@xenotime.net>
	 <20081028181402.GB4873@suse.de> <slrngghcgf.3do.jmm@inutil.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 2:57 PM, Moritz Muehlenhoff <jmm@debian.org> wrote:
> Greg KH wrote:
>> Of course, if someone doesn't want their code in the staging tree, I
>> will not add it, that's just being "nice".
>>
>> As for what I will not put into staging, right now I'm sticking with
>> drivers only, no filesystems (people have asked already).  I don't think
>> we have seen any drivers that I will not put into the staging tree yet.
>
> Hi Greg,
> Great effort with staging, thanks a lot!
>
> I've had a look at the out-of-tree kernel drivers currently present
> in Debian, maybe you want to merge some into staging. The Debian
> overview pages contain download links (the orig.tar.gz files):
>
> Acer hotkey driver:
> http://packages.qa.debian.org/a/acerhk.html
> http://www.cakey.de/acerhk/
>
> Synaptics cPad:
> http://packages.qa.debian.org/c/cpad-kernel.html
> http://www.janerob.com/rob/ts5100/cPad/index.shtml
>
> 3Dfx driver:
> http://packages.qa.debian.org/d/device3dfx.html
> http://glide.sourceforge.net/
>
> et131x Ethernet Controller:
> http://packages.qa.debian.org/e/et131x.html
> http://sourceforge.net/projects/et131x/

This driver (or a driver for the same hardware) is in staging already.

>
> GPIB (IEEE 488) drivers:
> http://packages.qa.debian.org/g/gpib.html
> http://linux-gpib.sourceforge.net/
>
> LEDs driver of PCEngines ALIX 2/3 boards:
> http://packages.qa.debian.org/l/leds-alix.html
> https://dev.openwrt.org/
>
> Kernel driver for the back-end scaler on Matrox cards:
> http://packages.qa.debian.org/m/mga-vid.html
> http://attila.kinali.ch/mga/
>
> ov51x-jpeg driver:
> http://packages.qa.debian.org/o/ov51x-jpeg.html
> http://www.rastageeks.org/ov51x-jpeg/index.php/Main_Page
>
> tp_smapi kernel modules:
> http://packages.qa.debian.org/t/tp-smapi.html
> http://tpctl.sourceforge.net/
>
> Voicetronix telephony hardware:
> http://packages.qa.debian.org/v/vpb-driver.html
> http://www.voicetronix.com.au/
>
> Cheers,
>        Moritz
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Greg,

If you're interested in having the above drivers get into staging and
need someone to email the developers about it, I humbly volunteer.

~J.R.
