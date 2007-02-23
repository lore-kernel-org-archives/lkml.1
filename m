Return-Path: <linux-kernel-owner+w=401wt.eu-S932491AbXBWSAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491AbXBWSAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 13:00:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932495AbXBWSAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 13:00:25 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:49666 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491AbXBWSAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 13:00:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JxZ6ykx9+feMkt52GK4tPDpDQZC3XyMKVpMHr5Qzr+Pb06V4T5AOqndagOQZip7uMbyHX28m2XLqacWGAxFqSo/r2pKKXaTSy9ttrA014SXp+Jg45Sb5b96iLEvUKOfHfVCJXWulAHklkxFEGeBTJJlgORnLAB/erJ7osa1puT8=
Message-ID: <a02278b00702231000l349bf810rfc39caaadf047d2e@mail.gmail.com>
Date: Fri, 23 Feb 2007 10:00:21 -0800
From: "Allexio Ju" <allexio.ju@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: trivial question regarding byte ordering
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0702231022400.7312@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a02278b00702230718i74df1d63g954bd7ac83298696@mail.gmail.com>
	 <Pine.LNX.4.64.0702231022400.7312@CPE00045a9c397f-CM001225dbafb6>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/23/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> #include <asm/byteorder.h>
>
> each architecture is responsible for including the appropriate header
> file for either big or little endianness.
Thank you for answer, Robert.

Allexio
