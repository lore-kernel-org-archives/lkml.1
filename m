Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbYI2MOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbYI2MOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 08:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbYI2MOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 08:14:05 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:59839 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbYI2MOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 08:14:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=x+QuYTWVyLx8+IvGwUXDvW0PkJ9M7djKEUFzTJLmF3hsZBCwYx1aV3loMddLMHQ6QW
         6tHAgo4s5WfLojKiSmqvFOEH/UrqSYTE8KFNFZHEtSW8fbqUWntIJkn/OC26JIutTTeu
         UUAItjNVipuIYrv1sktBgNciliKehREuTvS4Q=
Message-ID: <e68bb3470809290514i40e66d48rf97924c93cb0fb91@mail.gmail.com>
Date: Mon, 29 Sep 2008 20:14:01 +0800
From: vincen <mcuos.com@gmail.com>
To: "Ben Dooks" <ben-linux@fluff.org>
Subject: Re: PATCH linux-2.6.27-rc7-git5]ARM:Add the Nuvoton w90P910 Platform support to LINUX-ARM tree
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
In-Reply-To: <20080929091555.GB14564@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e68bb3470809280515v2079e787yf190af69ea1be3ab@mail.gmail.com>
	 <20080929091555.GB14564@fluff.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear sir,

Thank you for your help.

2008/9/29, Ben Dooks <ben-linux@fluff.org>:
> On Sun, Sep 28, 2008 at 08:15:10PM +0800, vincen wrote:
> > From: vincen.zswan mcuos.com@gmail.com
> >
> > Dear sir,
> > I have add the Nuvoton ARM series IC W90P910 Platform support to LINUX
> > ARM tree and make a patch named patch-2.6.27-rc7-git5-w90p910.patch.
> >
> > As the file size 177kb,so you can get the patch file from link:
> >
> > http://www.mcuos.com/attachment.php?aid=583
>
> If posting large patches, it would generally be much easier to split
> them into smaller chunks of logical changes. For an example, the defconfig
> addition could be seperated from the main submission, etc.
>
> > If the patch file is not accepted by Linux, please give some advice ,
> > I need to modify it better.thanks!
> >
> > Only add the mach-w90x900 directory to /linux/arch/arm and modify
> > Makefile and Kconfig.
> > Now,The Platform code support only uart driver and add the
> > w90p910_serial.c to /driver/serial and  modify Makefile and Kconfig.
> >
> > The Platform default config in arch/arm/configs/w90p910_defconfig
> >
> > Changes:
> > patching file arch/arm/Kconfig
> > patching file arch/arm/Makefile
> > patching file arch/arm/configs/w90p910_defconfig
> >
> > patching file arch/arm/mach-w90x900
> >
> > patching file arch/arm/mm/Kconfig
> > patching file drivers/serial/Kconfig
> > patching file drivers/serial/Makefile
> > patching file drivers/serial/w90x900_serial.c
> > patching file include/linux/serial_core.h
> >
> > --
> > Vincen
> > Signed-off-by: vincen.zswan <mcuos.com@gmail.com>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
>
> --
> Ben (ben@fluff.org, http://www.fluff.org/)
>
>  'a smiley only costs 4 bytes'
>


-- 
www.mcuos.com Best Regarts, Vincen
