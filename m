Return-Path: <linux-kernel-owner+w=401wt.eu-S1031188AbXHMRMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031188AbXHMRMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S948203AbXHMQxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 12:53:22 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:51580 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S948157AbXHMQxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 12:53:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=azxVjnZMbpOx8hXTzThmldczEkYbT8767/oYLkCuKwe50pookV2cyWiCAxR0AVnMhHtGxZZ6LGYdaCTlFxHzFpGl+mbrVd6cFhSvFxdGl7lJUIGzZ3Kc4f5IunRMjJGripHM76op3SNw0wP3CPAHF+Qv+v8YTLObkV1bX/5SO0Q=
Message-ID: <499d6ed30708130953q406bfd47k696d01ef8cfb4808@mail.gmail.com>
Date: Mon, 13 Aug 2007 11:53:14 -0500
From: "Kent Yoder" <shpedoikal@gmail.com>
To: "joe@perches.com" <joe@perches.com>
Subject: Re: [tpmdd-devel] [PATCH] [450/2many] MAINTAINERS - TPM DEVICE DRIVER
Cc: tpmdd-devel@lists.sourceforge.net, tpm@selhorst.net,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       kjhall@us.ibm.com, akpm@linux-foundation.org
In-Reply-To: <46bffbe5.GV+GkdQ7k/UTWFWW%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46bffbe5.GV+GkdQ7k/UTWFWW%joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ack'd by Kent Yoder

On 8/13/07, joe@perches.com <joe@perches.com> wrote:
> Add file pattern to MAINTAINER entry
>
> Signed-off-by: Joe Perches <joe@perches.com>
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 14633c4..cd9cda4 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4284,6 +4284,7 @@ M:        tpm@selhorst.net
>  W:     http://www.prosec.rub.de/tpm/
>  L:     tpmdd-devel@lists.sourceforge.net
>  S:     Maintained
> +F:     drivers/char/tpm/
>
>  Telecom Clock Driver for MCPL0010
>  P:     Mark Gross
>
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Splunk Inc.
> Still grepping through log files to find problems?  Stop.
> Now Search log events and configuration files using AJAX and a browser.
> Download your FREE copy of Splunk now >>  http://get.splunk.com/
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
>


-- 
Kent Yoder
IBM LTC Security Dev.
