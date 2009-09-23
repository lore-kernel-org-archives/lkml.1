Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbZIWG2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbZIWG2L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 02:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbZIWG2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 02:28:11 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:49876 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbZIWG2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 02:28:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LzOCcn7DxyCjRvgvB3ri1oa+WRZP6j37C/pjg1zw8heCbqmUYQ7MjF3mt6sKMTb0hN
         UJPwOwnBDEK968uFgALp0rcTQlYQfRCfK8mGEBVJfkflOMUPqbbWgD7jA10jYGL046Le
         tWY3/yBm33GsPQ0yJDJcwWKjMV4A7tJU9xTjU=
Date: Tue, 22 Sep 2009 23:28:09 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH v2] input/keyboard: new driver for ADP5520 MFD PMICs
Message-ID: <20090923062808.GD1458@core.coreip.homeip.net>
References: <1253211850-29309-1-git-send-email-vapier@gentoo.org> <1253682916-27387-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253682916-27387-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 01:15:16AM -0400, Mike Frysinger wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
> 
> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
> this patch requires:
> 	[PATCH] mfd: ADP5520 Multifunction LCD Backlight and Keypad Input Device Driver
> 
> v2
> 	- address feedback from Dmitry
> 

Looks good. I assume you want it to be merged with the rest of ADP5520
patches, so:

Acked-by: Dmitry Torokhov <dtor@mail.ru>

-- 
Dmitry
