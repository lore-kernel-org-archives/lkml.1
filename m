Return-Path: <linux-kernel-owner+w=401wt.eu-S1752246AbZL3GSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbZL3GSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 01:18:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbZL3GSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 01:18:23 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:59910 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbZL3GSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 01:18:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eHkwKZpj82nVy8thJTLqVg/AQBTVgPBl18+xCvTZy7Xm0s5TDMoh4wG03ZDU4RI5ok
         TEfkfMkK1ZmUKtJRhbTfWdBWcYo86CHAX1Xa4xu2q8hH480YH7xEmjSZZeKRbQFZfSko
         2VKbKCXDIiEHROVGu9YRKoTraAJNSdvlAFXx0=
Date: Tue, 29 Dec 2009 22:18:15 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Miloslav Trmac <mitr@volny.cz>
Subject: Re: [PATCH] input, misc: Fix CONFIG_PM defination in wistron_btns.c
Message-ID: <20091230061815.GH2186@core.coreip.homeip.net>
References: <b9df5fa10912281957n5b0ab34fgc1b2ffb239fb8e87@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9df5fa10912281957n5b0ab34fgc1b2ffb239fb8e87@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 29, 2009 at 09:57:41AM +0600, Rakib Mullick wrote:
>  Fix CONFIG_PM defination.
> We were warned by the following warning:
> 
> drivers/input/misc/wistron_btns.c:1331:5: warning: "CONFIG_PM" is not defined
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

Applied, tahnk you Rakib.

-- 
Dmitry
