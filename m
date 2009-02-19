Return-Path: <linux-kernel-owner+w=401wt.eu-S1758794AbZBSGzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794AbZBSGzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 01:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754511AbZBSGzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 01:55:24 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:51632 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbZBSGzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 01:55:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=qsjBkN/Vh9jmzL6AQDG2py2u9kqE/F/CehWM5jqhuqab+ClNooWUhCp44h22eu4V7p
         /bkzv3od2uGCs4ACMAjXwhwlkPPly+924Ro3fsWAfwkQGgJU9jvbDs8bfhU8THn1blay
         labcGgmA3nMZM4b+J5kEwiVqD0tu46uTvRvmk=
Date: Thu, 19 Feb 2009 07:50:00 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide-cd: minor ide_cdrom_setup() cleanup
Message-ID: <20090219065000.GB11664@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200902182019.33997.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200902182019.33997.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 08:19:33PM +0100, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide-cd: minor ide_cdrom_setup() cleanup
> 
> Cache drive->queue in local variable and use max().
> 
> There should be no functional changes caused by this patch.
> 
> Cc: Borislav Petkov <petkovbb@gmail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Borislav Petkov <petkovbb@gmail.com>

-- 
Regards/Gruss,
    Boris.
