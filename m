Return-Path: <linux-kernel-owner+w=401wt.eu-S1752303AbXF3Aeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbXF3Aeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 20:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbXF3Aeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 20:34:36 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:43873 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbXF3Aef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 20:34:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=r32z9S24P/gx5CKkWYN+rVzV6vCOTNxhY8h8D4Xu+n3EEqepPUWy6HZoKE9RB+y2QF1Eam0z+hY514j+LxtT0hzMMzduqj5ZVpd2juPhr1XzsnU+MnGDCsv8MbJyj9A+3HvYr0JFZcWRQub01MH89CKNgJAmR49RLBFYtyyIMm0=
Message-ID: <9c4865a10706291734x794510b2t8cabc2478c0e01f5@mail.gmail.com>
Date: Fri, 29 Jun 2007 20:34:34 -0400
From: "Russell Harmon" <eatnumber1@gmail.com>
To: "Frank Fiene" <ffiene@veka.com>
Subject: Re: Kernel doesn't recognize complete memory
Cc: linux-kernel@vger.kernel.org, tytso@thunk.org
In-Reply-To: <200706292225.26503.ffiene@veka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706292225.26503.ffiene@veka.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

http://kerneltrap.org/node/2450/7217 is likely your problem, although
why you can see 3gb instead of only 1gb of ram, idk... maybe something
ubuntu specific...

On 6/29/07, Frank Fiene <ffiene@veka.com> wrote:
> Lenovo Z61p, Intel Core2 Duo T7200
>
> I have 4GB RAM installed and BIOS recognize 4GB RAM.
> Linux kernel (Ubuntu-7.04, 32bit-PAE and 64bit, openSUSE-10.2 32bit-PAE
> and 64bit) tells me: only 3GB of RAM are installed.
>
> Any other user with a 4GB Thinkpad? tytso?
>
> What can i do? Please help!
>
> Regards
> Frank
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
