Return-Path: <linux-kernel-owner+w=401wt.eu-S1751312AbXEXOHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312AbXEXOHD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 10:07:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750750AbXEXOGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 10:06:52 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:31827 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbXEXOGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 10:06:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=nf1s9SmCMYMpdNGt71D613yTUqBLZtGDj7bvSL8aVoyFtTQv75j0qIQHANPJ+mfWQY1G2+n2s2FqCxSWEYB3u0pz4YTKu+zd7y0U5ahkA7dkYRn8Css6AxYsV/8ZF5rt2aZX3ITMudXJJ3IQkGudjdzo2fiIxfKDX1xRzZme/Tg=
Message-ID: <2c0942db0705240706n48152c73v810f3a147f646033@mail.gmail.com>
Date: Thu, 24 May 2007 07:06:44 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: [1/3] 2.6.22-rc2: known regressions v2
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       "Len Brown" <lenb@kernel.org>
In-Reply-To: <46559B49.8020304@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46559B49.8020304@googlemail.com>
X-Google-Sender-Auth: 311662a3c79b5c31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/24/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> Here is a list of some known regressions in 2.6.22-rc2.
>
> Feel free to add new regressions/remove fixed etc.
> http://kernelnewbies.org/known_regressions
>
> ACPI
>
> Subject    : nx6125 has lost fan control
> References : http://lkml.org/lkml/2007/5/16/249
> Submitter  : Ray Lee <ray-lk@madrabbit.org>
> Status     : Unknown

I'm withdrawing this. It's not a regression, and Raphael (an nx6325
owner) says it does it on his system as well from time to time. It's
just another example of the sad state of the firmware on this laptop.

Thanks,

~r.
