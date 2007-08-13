Return-Path: <linux-kernel-owner+w=401wt.eu-S948237AbXHMQWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S948237AbXHMQWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936425AbXHMPJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 11:09:46 -0400
Received: from el-out-1112.google.com ([209.85.162.180]:56776 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S945918AbXHMPJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 11:09:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Q5YEkQOdpXfYcd8Z//SYQ9xBDyhM6Z9O0Pz4XWWfMjLT9lEEUrkr6MnIz0phV+e+OcqcPsS8inNEzHTy/4WKov8M6gEaYXeZ9ykBaUn70tcGzpb21ZS910FA/dFBllLX/qvyR+2MYTlgVTmCsfPs/1b7iYWcKFqx09hgG5uvUjg=
Message-ID: <524f69650708130809w4717d8e2mb53ba94a6431aacb@mail.gmail.com>
Date: Mon, 13 Aug 2007 10:09:37 -0500
From: "Steve French" <smfrench@gmail.com>
To: "joe@perches.com" <joe@perches.com>
Subject: Re: [PATCH] [123/2many] MAINTAINERS - COMMON INTERNET FILE SYSTEM (CIFS)
Cc: torvalds@linux-foundation.org, sfrench@samba.org,
       samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
       linux-cifs-client@lists.samba.org, akpm@linux-foundation.org
In-Reply-To: <46bff94b.cqAV08ZZtCVJZMCU%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46bff94b.cqAV08ZZtCVJZMCU%joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yes - I will fix this up.

On 8/13/07, joe@perches.com <joe@perches.com> wrote:
> Add file pattern to MAINTAINER entry
>
> Signed-off-by: Joe Perches <joe@perches.com>
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1c014f1..5144e4e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1201,6 +1201,7 @@ L:        samba-technical@lists.samba.org
>  W:     http://us1.samba.org/samba/Linux_CIFS_client.html
>  T:     git kernel.org:/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
>  S:     Supported
> +F:     fs/cifs/
>
>  CONFIGFS
>  P:     Joel Becker
>


-- 
Thanks,

Steve
