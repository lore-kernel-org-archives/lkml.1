Return-Path: <linux-kernel-owner+w=401wt.eu-S1759084AbYIAQvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759084AbYIAQvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 12:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756072AbYIAQvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 12:51:40 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:9422 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbYIAQvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 12:51:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=t78suJhhu/FjBdEb8oT6u5KmrhrzS/jndAM0SOcyO4vJSAGyqwbIOAEK5RfGgZtocd
         nWuVVdkorxTM8UvWSzVkZAifqaR7JvW6Tzmwv6/Tf8CY+tRGSc3QEfp8Ty1PdLH6QY64
         k28fs8A/4CSCWoCGdAUH72JksrXebNnkbQBJU=
Message-ID: <3f9a31f40809010951p15ed7359w48d2b18adf0ca20f@mail.gmail.com>
Date: Mon, 1 Sep 2008 12:51:39 -0400
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: "Gene Heskett" <gene.heskett@gmail.com>
Subject: Re: Linux-2.6.27-rc5, drm errors in log
Cc: "Dave Airlie" <airlied@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <200808310655.45464.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <898503EB1E15BA4F944D1BE69D55AAC8AB540A@storexmb1.amd.com>
	 <200808302219.45103.gene.heskett@verizon.net>
	 <21d7e9970808302340w71483645macb34f8470a85c66@mail.gmail.com>
	 <200808310655.45464.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Gene,

On Sun, Aug 31, 2008 at 6:55 AM, Gene Heskett <gene.heskett@gmail.com> wrote:
>
> Yes I can, but how do I get that specific patch?  Or is that the git # for the
> patch I first applied to -rc2, which added the firmware/radeon stuff?  I'm
> familiar with patch, but not on a first name basis with git, sorry.
>
> So I'm going to do a bisect, my style.  I will rebuild, starting with -rc3,
> using only the -rcX patch and the firmware addition patch, which applied to
> -rc3 as follows:
> now applying [PATCH]radeon_cp-use-request_firmware
>

This patch is not included in 2.6.27-rc5. Please do not mix this patch
now, first resolve your problem and if you want then you can add this
patch above of it.

Thank you,

Jaswinder Singh.
