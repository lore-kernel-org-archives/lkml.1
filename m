Return-Path: <linux-kernel-owner+w=401wt.eu-S1758374AbZCSFjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758374AbZCSFjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 01:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbZCSFjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 01:39:31 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:28050 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbZCSFj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 01:39:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=tjAoFWofbUl5q8cV/hclhGfRaHHyYziYoYBi6ivOZUqA37/tQk5buozlr+uTfZMv5o
         2m+a1xDzg0Xywwz//DRsvpX+FT+LFxOsCBAwQekJ3pFOEylYsj9HpJQ4uOJ3xuLZwdmE
         z2tskGxL8Nas7B3hDktpnL7xuvNtYyGNNfNNI=
Date: Thu, 19 Mar 2009 06:39:19 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Gadi Oxman <gadio@netvision.net.il>,
       Paul Bristow <paul@paulbristow.net>
Subject: Re: [PATCH] MAINTAINERS: move old ide-{floppy,tape} entries to
	CREDITS
Message-ID: <20090319053919.GA24137@liondog.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
	Gadi Oxman <gadio@netvision.net.il>,
	Paul Bristow <paul@paulbristow.net>
References: <200903182201.32668.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200903182201.32668.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 10:01:32PM +0100, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] MAINTAINERS: move old ide-{floppy,tape} entries to CREDITS
> 
> Ben Hutchings noticed that MAINTAINERS somehow still contain old
> ide-{floppy,tape} entries.  Fix it by moving them to CREDITS (kudos
> to Gadi and Paul for all the early hard work on ide-{floppy,tape}).
> 
> Cc: Gadi Oxman <gadio@netvision.net.il>
> Cc: Paul Bristow <paul@paulbristow.net>
> Cc: Borislav Petkov <petkovbb@gmail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> Borislav, maybe it would make sense to rename IDE/ATAPI CDROM DRIVER
> entry to IDE/ATAPI DRIVERS one nowadays (you're the one doing most of
> ATAPI work anyway :)?

... after you, of course :).

Fine with me. The easiest would be if you fold the change into the same patch.

> 
>  CREDITS     |    9 +++++++++
>  MAINTAINERS |   13 -------------
>  2 files changed, 9 insertions(+), 13 deletions(-)

-- 
Regards/Gruss,
    Boris.
