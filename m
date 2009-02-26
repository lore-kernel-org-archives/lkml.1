Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbZBZNut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbZBZNut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 08:50:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbZBZNul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 08:50:41 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60783 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbZBZNuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 08:50:40 -0500
Date: Thu, 26 Feb 2009 14:50:38 +0100
From: Jan Kara <jack@suse.cz>
To: Kazuo Moriwaka <moriwaka@gmail.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] jbd header comment typo fix
Message-ID: <20090226135038.GA976@atrey.karlin.mff.cuni.cz>
References: <b294a32a0902052218y6f4f9f75h5616f285d306e9d9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b294a32a0902052218y6f4f9f75h5616f285d306e9d9@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  CCing trivial tree which is probably the best place for this.

								Honza

> Sighned-off-by: Kazuo Moriwaka <moriwaka@redhat.com>
> 
>     jbd header comment typo fix
> 
> ---
>  jbd.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> diff --git a/include/linux/jbd.h b/include/linux/jbd.h
> index 64246dc..e8ca681 100644
> --- a/include/linux/jbd.h
> +++ b/include/linux/jbd.h
> @@ -35,7 +35,7 @@
>  #define journal_oom_retry 1
> 
>  /*
> - * Define JBD_PARANIOD_IOFAIL to cause a kernel BUG() if ext3 finds
> + * Define JBD_PARANOID_IOFAIL to cause a kernel BUG() if ext3 finds
>   * certain classes of error which can occur due to failed IOs.  Under
>   * normal use we want ext3 to continue after such errors, because
>   * hardware _can_ fail, but for debugging purposes when running tests on
> 
> --
> Kazuo Moriwaka
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
