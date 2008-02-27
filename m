Return-Path: <linux-kernel-owner+w=401wt.eu-S1761373AbYB0VIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761373AbYB0VIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758522AbYB0VH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:07:27 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:34592 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbYB0VHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:07:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=ORhe0sskp0eIm2Mp5ElEM5kxeVA+oM+HhRgaZaVIo4hKMYHsyF5creCfPi/F9VBCx4zmIajQecJT4A++xR3JEIjwKtthYCxG8Bxcd5jYmD4UIuoWYTbBLbxzKgLrVrjSuBc2ZeUU+6PKX+vGA1g5ooexJPqsbGyElMmjuQ0KSC8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 0/5] ide-cd: trivial fixes
Date: Wed, 27 Feb 2008 22:18:40 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1204136449-9490-1-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1204136449-9490-1-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802272218.40312.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday 27 February 2008, Borislav Petkov wrote:
> Hi Bart,
> 
> here are the ide-cd trivial fixes split in an easier to digest format. I
> cannot do the md5sum check here since all of the patches change at least one
> char but i hope that this'll be redundant here since they're trivially easy
> to review :) now.
> 
>  drivers/ide/ide-cd.c |  591 +++++++++++++++++++++++++-------------------------
>  1 files changed, 298 insertions(+), 293 deletions(-)

applied everything

BTW patch #3/5 which accounts for 2/3 of the diffstat passes md5sum check here
