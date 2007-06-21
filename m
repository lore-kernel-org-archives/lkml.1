Return-Path: <linux-kernel-owner+w=401wt.eu-S1756642AbXFUToW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbXFUToW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 15:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757155AbXFUTnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 15:43:55 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:21928 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818AbXFUTny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 15:43:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=RaHgRhlsZ2Zmhe39fUnLWfJt9s3Jd4TzdDboXvak8gfIKr2tTVFlP7hm2q37vUsZf7inmQ3OseVLZkCgOcZer1+WKgo5R081eME6a73GT3dF73Xp+VJ3hg6fMMI8Oi3io+k95jzqgFsFAm5pIYl4i9tJH4YPDDab03S09VO5Efs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Masatake YAMATO <jet@gyve.org>
Subject: Re: [PATCH] never called printk statement in ide-taskfile.c::wait_drive_not_busy
Date: Thu, 21 Jun 2007 21:56:26 +0200
User-Agent: KMail/1.9.6
Cc: cebbert@redhat.com, linux-kernel@vger.kernel.org
References: <4665988A.5060902@redhat.com> <200706160045.36638.bzolnier@gmail.com> <20070618.030552.59480211.jet@gyve.org>
In-Reply-To: <20070618.030552.59480211.jet@gyve.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706212156.26921.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 June 2007, Masatake YAMATO wrote:
> > Please re-submit this fix in the form of a patch so I can merge it.
> 
> Here it is.

Applied but please remember to always include patch description when
sending the improved version of the patch.  This time I fixed it manually
to speed up the procedure.

Thanks,
Bart
