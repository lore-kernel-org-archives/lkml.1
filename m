Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbYBDRaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbYBDRaj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 12:30:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755653AbYBDRab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 12:30:31 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:10766 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896AbYBDRaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 12:30:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=x3rap4kOEmiE7JSZVP3bV/TSMHHg/3H5IT3+TGGgzjMtiR4JmuLg5aYbYx+BtaJ5iRanvT5VEYRHUnaFfHgQcd4ac0It0wdnckHKYFicUEkvwHLQEG3qhJMf9kUzWIq9CrXDLFk7xEjcz2E18la2ZSi1DbnpOmBSlDdl+hSPUQs=
Message-ID: <6101e8c40802040930v7d9dcd85jd37fadd05246664f@mail.gmail.com>
Date: Mon, 4 Feb 2008 18:30:28 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: [patch 00/27] 2.6.22-stable review
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       "Justin Forbes" <jmforbes@linuxtx.org>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Dave Jones" <davej@redhat.com>,
       "Chuck Wolber" <chuckw@quantumlinux.com>,
       "Chris Wedgwood" <reviews@ml.cw.f00f.org>,
       "Michael Krufky" <mkrufky@linuxtv.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Domenico Andreoli" <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20080202001927.GA8368@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080202001927.GA8368@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/2/08, Greg KH <gregkh@suse.de> wrote:
> This is the start of the stable review cycle for the 2.6.22.17 release.
> There are 27 patches in this series, all will be posted as a response to
> this one.  If anyone has any issues with these being applied, please let
> us know.  If anyone is a maintainer of the proper subsystem, and wants
> to add a Signed-off-by: line to the patch, please respond with it.
>
> These patches are sent out with a number of different people on the
> Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
> to add your name to the list.  If you want to be off the reviewer list,
> also email us.
>
> Responses should be made by Feb 5 2008, 00:00:00 UTC.  Anything received
> after that time might be too late.
>
> Note, I think this is going to be the last .22 release, unless people
> send me some patches they think really needs to go in, and then, it will
> probably only be one more release.  It's time to move on :)

hmm it is not a long time supperted kernel, like 2.6.16.y ? ;)

>
> thanks,
>
> the -stable release team
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
