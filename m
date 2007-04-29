Return-Path: <linux-kernel-owner+w=401wt.eu-S1756436AbXD2MP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436AbXD2MP2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 08:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756428AbXD2MP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 08:15:28 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:60578 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436AbXD2MPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 08:15:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HjDW/ucZBon+abXyVPBhTX9bXYP/8RQF2j9InasrmKNarKOjJ2QYOdLVCCUpk8m+vhkz71MsgGACD88WW7kJlHNW+IcuxfGAuIcPtL4N3eywLWHKgsfpG+4caUt3c7EOWbcaR42HyD1a/VnGBH0m4wLWTlsV+XZSiVCNbZ6KrD0=
Message-ID: <6bffcb0e0704290515h51cf5064y7310203a84cecd73@mail.gmail.com>
Date: Sun, 29 Apr 2007 14:15:23 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Brett Ryland" <nappers@gmail.com>
Subject: Re: PROBLEM: oops in 2.6.21.1 after bringing up the network
Cc: "Daniele Venzano" <venza@brownhat.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200704300000.25594.b.n.ryland@massey.ac.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200704300000.25594.b.n.ryland@massey.ac.nz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brett,

On 29/04/07, Brett Ryland <nappers@gmail.com> wrote:
> Hi,
> I am consistently getting a kernel oops from a vanilla 2.6.21.1 kernel. It
> also occurs in vanilla 2.6.21, but not in 2.6.20.8. The relevant section of
> the kernel is networking, in particular the sis900 module (I think).
> The attached file contains the oops and the information asked for on the site
> http://www.kernel.org/pub/linux/docs/lkml/reporting-bugs.html for reporting
> kernel oopses. The oops fully crashes my computer and leaves the capslock and
> numlock leds flashing, so the oops is transcribed by hand from a photo
> (hopefully I haven't made a mistake, I do still have the photo if it's
> needed).
>
> I'm not subscribed to the mailing list so please CC any questions/solutions to
> me.
>
> Regards,
> Nappers.
>
>

I added your report to known regressions
(http://kernelnewbies.org/known_regressions). Please send your .config
file.

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
