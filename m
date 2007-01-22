Return-Path: <linux-kernel-owner+w=401wt.eu-S932543AbXAVW1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543AbXAVW1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 17:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932544AbXAVW1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 17:27:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:63154 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932543AbXAVW1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 17:27:18 -0500
Date: Mon, 22 Jan 2007 23:26:58 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Tony Foiani <tkil@scrye.com>
cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Eduard Bloch <edi@gmx.de>,
       Bodo Eggert <7eggert@gmx.de>, David Schwartz <davids@webmaster.com>,
       Leon Woestenberg <leon.woestenberg@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: KB->KiB, MB -> MiB, ... (IEC 60027-2)
In-Reply-To: <gsle2n9tz.fsf@brand.scrye.com>
Message-ID: <Pine.LNX.4.58.0701222159110.4293@be1.lrz>
References: <7FsPf-51s-9@gated-at.bofh.it> <7FxlV-3sb-1@gated-at.bofh.it>
 <7FyUF-5XD-21@gated-at.bofh.it> <E1H8a7s-0000at-Jx@be1.lrz>
 <20070121111000.GA6679@rotes76.wohnheim.uni-kl.de> <20070122155354.GB25916@csclub.uwaterloo.ca>
 <Pine.LNX.4.61.0701221756000.317@yvahk01.tjqt.qr> <20070122183619.2db6538e@localhost.localdomain>
 <gsle2n9tz.fsf@brand.scrye.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:9b3b2cc444a07783f194c895a09f1de9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jan 2007, Tony Foiani wrote:

> >>>>> "Jan" == Jan Engelhardt <jengelh@linux01.gwdg.de> writes:
> 
> Jan> For "F"s sake, when you gotta use abbreviations, then just use
> Jan> k=1000 and K=1024 already, b for bits and B for bytes. Problem
> Jan> gone.
> 
>    The one-letter abbreviations are identical to SI prefixes, except
>    for "K", which is used interchangeably with "k" (in SI, "K" stands
>    for the kelvin, and only "k" stands for 1,000).
> 
>    [...]
> 
>    BIPM (which maintains SI) expressly prohibits the binary prefix
>    usage, and recommends the use of the IEC prefixes as an alternative
>    (computing units are not included in SI).
> 
>    Some have suggested that "k" be used for 1,000, and "K" for 1,024,
>    but this cannot be extended to the higher order prefixes and has
>    never been widely recognised.
>    -- http://en.wikipedia.org/wiki/Binary_prefix
> 
> So if you continue insisting that "MB" is really 2^20 bytes, you're
> flouting the SI in at least two ways.

The use of SI is not even accepted on bytes.
See <URL:http://www.bipm.org/utils/common/pdf/si_brochure_8_en.pdf>.

Therefore "MB" is undefined in the SI world, and 2^20 B in the IT world.

>  I'd expect that from an USAian,
> not a German.  ;-> (To be clear, I *am* a USAian, and I really
> desperately wish this country were metric...)

I'd even prefer decimal hours, minutes and seconds.

> Some other gems from that article that haven't been covered in this
> thread:
> 
>  * CD-Rs are generally specified in MiB, but DVD-Rs in GB
>  * CPU clocks are given in decimal

Hz is a supplementary SI unit.
-- 
"Those who would give up essential liberty, to purchase a little
temporary safety, deserve neither liberty nor safety."
	-- Benjamin Franklin, Historical Review of Pennsylvania, 1759
