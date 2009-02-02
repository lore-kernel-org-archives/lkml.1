Return-Path: <linux-kernel-owner+w=401wt.eu-S1758121AbZBBUyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121AbZBBUyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 15:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbZBBUyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 15:54:13 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:27467 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbZBBUyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 15:54:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DiVEi1Lt1+CSxby2lfngfz0U5wpVZfd+bNaG0DUoj7DYSbPuDnZvIBZYjOZbu6sgNz
         B9ICHoQlT1kRCTDkDyeDb1FsWjHY7UhB0rPd60FzW86ER4ejg+8F6LXqF7S4LPNMstpp
         QrvHaROXTUuQyudtoUIEpcsUku4FZnwJvsLAg=
MIME-Version: 1.0
In-Reply-To: <49845853.3020402@artecdesign.ee>
References: <49845853.3020402@artecdesign.ee>
Date: Mon, 2 Feb 2009 22:54:10 +0200
Message-ID: <cd73a99e0902021254u43c179c2x918cf323a6b86bf5@mail.gmail.com>
Subject: Re: [PATCH] Fix for Atmel AT91 powersaving
From: Andrew Victor <avictor.za@gmail.com>
To: Andrei Birjukov <andrei.birjukov@artecdesign.ee>
Cc: linux@maxim.org.za, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Andrei,

> This patch fixes correct restoring of LPR register of the Atmel AT91 SDRAM
> controller when returning from a power saving mode.
>
> Signed-off-by: Andrei Birjukov <andrei.birjukov@artecdesign.ee>

Acked-by: Andrew Victor <linux@maxim.org.za>

Thanks.
Please submit the patch to Russell King's patch-tracking system.
  <http://www.arm.linux.org.uk/developer/patches/>


Regards,
  Andrew Victor
