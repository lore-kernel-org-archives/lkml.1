Return-Path: <linux-kernel-owner+w=401wt.eu-S1756308AbXIMMl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308AbXIMMl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 08:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbXIMMlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 08:41:20 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:29045 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbXIMMlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 08:41:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XcI8jriWbEVAYgMgxCBfe+UFVbPUlvkQ+3axDP62uJD6FoXiDHfvt3s1dRij3sG3476s06+0ve++cTPt7K5UKNUHPkdHS2g3LK+W0apxKHT7AcvrKvVYF3PoY/ioLnR9ev/ft9/AH6XRqsBQtV6eafY92qMlY7y8J2lkjnmUYlQ=
Message-ID: <6bffcb0e0709130541t364e5b83q48d4711347c7fd0b@mail.gmail.com>
Date: Thu, 13 Sep 2007 14:41:19 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Frank Liu" <frank.liu64@gmail.com>
Subject: Re: [linux-kernel]how to get the latest kernel source tree?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <f405816b0709130537u2e038053tca1a96f6711952f8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f405816b0709130534k11fc5ca0r4f9ac1f0ea9725e@mail.gmail.com>
	 <f405816b0709130537u2e038053tca1a96f6711952f8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frank,

On 13/09/2007, Frank Liu <frank.liu64@gmail.com> wrote:
> For some reason I was not able to use git, but I still wanna get the
> latest kernel source tree as I hope to submit a patch, hence I am now
> about to do the things like this:
>
> -download kernel 2.6.22.6 as this is the latest stable version
> -and download patch-2.6.23-rc6.bz2 and decompressed it

This patch is against 2.6.22, not 2.6.22.6

> -apply patch-2.6.23-rc6 against 2.6.22.6 source tree
>
> Is this reasonable?
> Thanks
>
> Regards
> Frank

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
