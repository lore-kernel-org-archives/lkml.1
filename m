Return-Path: <linux-kernel-owner+w=401wt.eu-S1763444AbXESRuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763444AbXESRuj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 13:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756096AbXESRuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 13:50:32 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:34704 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbXESRuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 13:50:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=b72aw6PQBMeazjBFM3ukC/5gO3UFEudoosRl0aSpx003R/DSeibY3j4H07OwTp4eUIyKxuIzKPV9H60t5nQqSWXmBpDx4VjWAJPpRvxNQbB6H/KG3x8//McgmrafF0uWf3o9GhekDOWwFSKW+IZtH9dIqYDpPZ/iHCi+di3iEDQ=
Message-ID: <6bffcb0e0705191050oeeda1a3ma3dc86715acf87b2@mail.gmail.com>
Date: Sat, 19 May 2007 19:50:31 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "oliver pinter" <oliver.pntr@gmail.com>
Subject: Re: it seems at XFS bug?!
Cc: xfs-masters@oss.sgi.com, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <6101e8c40705191046t29cdad68oe4e613b6c71deb93@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6101e8c40705191046t29cdad68oe4e613b6c71deb93@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding xfs-masters to CC]

On 19/05/07, oliver pinter <oliver.pntr@gmail.com> wrote:
> pancs:~/kernel# ll
> total 460
> -rw-r--r-- 1 root root      0 2007-05-19 19:36
> -rwxr-xr-x 1 root root    259 2007-05-06 13:14 lspc.sh
> -rw-r--r-- 1 root root  92184 2007-05-06 13:06 mypc.txt
> -rw-r--r-- 1 root root  91058 2007-05-06 12:42 pc.tct
> -rw-r--r-- 1 root root  93834 2007-05-06 12:58 pc.txt
> -rw-r--r-- 1 root root 182116 2007-05-06 12:39 tet
> -rw-r--r-- 1 root root      0 2007-05-06 12:41
>
> the last line is very interesting, this file has no name and the size is 0 byte.
>
> I have several times booting and using the 2.6.21-git1 .. 2.6.22-rc2 kernels.
> And now I use   2.6.21.1.
>
> This error have yet others to happen.
>
> (sorry for the bad spelling, I not learned  english)
> -

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
