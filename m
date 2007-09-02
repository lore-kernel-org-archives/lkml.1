Return-Path: <linux-kernel-owner+w=401wt.eu-S934195AbXIBWWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934195AbXIBWWM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 18:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756187AbXIBWVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 18:21:54 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:1287 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150AbXIBWVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 18:21:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nK+YeNnq2LvNa848pjSDbJ9bMGuM79PKeAO6xVWEW4AsopkCzl7+SsK3NfLbbhv4mnJDJJTHUihYgt8aTtWsh2qKDncz5FvZKvXHetGJjrvIas59uP/gOHUquJHZ0eU0ZZKVP3Cr7oMYIPjpV7GoQog7VPh8t8zlQcmL6KxrO9k=
Message-ID: <be1b757c0709021521q850f2bdq3f88c24c02c26b1b@mail.gmail.com>
Date: Mon, 3 Sep 2007 00:21:50 +0200
From: "Karl Meyer" <adhocrocker@gmail.com>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: PROBLEM: 2.6.23-rc "NETDEV WATCHDOG: eth0: transmit timed out"
Cc: "Francois Romieu" <romieu@fr.zoreil.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <6bffcb0e0709021515v586f078cjce04f877e2f27aa2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <be1b757c0708130435y689b9dd8raf9ac9f9c0fcc976@mail.gmail.com>
	 <20070813165821.GA19356@electric-eye.fr.zoreil.com>
	 <be1b757c0708131027v5c57822as2d9bd3190fd19b71@mail.gmail.com>
	 <20070814070901.GA14693@electric-eye.fr.zoreil.com>
	 <be1b757c0708141425qd887581n3922702b84a21758@mail.gmail.com>
	 <20070814224629.GB3495@electric-eye.fr.zoreil.com>
	 <20070816141122.GA6625@electric-eye.fr.zoreil.com>
	 <be1b757c0709011224tafebaaby697d03ab5377e20f@mail.gmail.com>
	 <6bffcb0e0709021515v586f078cjce04f877e2f27aa2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

am am looking for this issue for some time now, but there where no
errors in 2.6.22-r2 (gentoo speak, I guess this is 2.6.22.2
officially), I also ran git-bisect (for more information see the older
messages in this thread).

2007/9/3, Michal Piotrowski <michal.k.k.piotrowski@gmail.com>:
> Hi,
>
> On 01/09/07, Karl Meyer <adhocrocker@gmail.com> wrote:
> > This is what happened today:
> >
> > Sep  1 21:08:01 frege NETDEV WATCHDOG: eth0: transmit timed out
> > frege ~ # uname -r
> > 2.6.22.5-cfs-v20.5
>
> Can you reproduce this on 2.6.22 (not 2.6.22.x - it might be a -stable
> regression)?
>
> Regards,
> Michal
>
> --
> LOG
> http://www.stardust.webpages.pl/log/
>
