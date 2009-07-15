Return-Path: <linux-kernel-owner+w=401wt.eu-S932119AbZGOQIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbZGOQIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 12:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755631AbZGOQIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 12:08:53 -0400
Received: from mail-vw0-f200.google.com ([209.85.212.200]:36933 "EHLO
	mail-vw0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755592AbZGOQIw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 12:08:52 -0400
X-Greylist: delayed 85767 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Jul 2009 12:08:51 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=JdLCsusC8dsVV+7ssFBVhl0Ie6DSoaUiF/6o1TntgeCh9smY83nXVcFr+0EpRCuSCz
         4pTIkNVBAjXDQ2EoIrDdzqLZ0OFwpFGfWXEcrsYx2nsphlyd3avBVfvO6db5+vrNSBkU
         yBQ7YNICJfSmEevcwIaYC/4T/7hxT9PXDaHwc=
MIME-Version: 1.0
In-Reply-To: <1245763114-7753-1-git-send-email-vapier@gentoo.org>
References: <1245763114-7753-1-git-send-email-vapier@gentoo.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 15 Jul 2009 12:08:31 -0400
Message-ID: <8bd0f97a0907150908y333f89eav1d0edbb6a5951c05@mail.gmail.com>
Subject: Re: [PATCH] USB: isp1760: allow platform devices to customize 
	devflags
To: Mike Frysinger <vapier@gentoo.org>
Cc: gregkh@suse.de, bigeasy@linuxtronix.de, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 09:18, Mike Frysinger wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
>
> Platform device support was merged earlier, but support for boards to
> customize the devflags aspect of the controller was not.  We want this on
> Blackfin systems to control the bus width, but might as well expose all of
> the fields while we're at it.

ping ...
-mike
