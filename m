Return-Path: <linux-kernel-owner+w=401wt.eu-S1032305AbXHMRMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032305AbXHMRMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S947996AbXHMQzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 12:55:40 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:14137 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939499AbXHMQzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 12:55:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pJrgrIM1kAuL2Nue9cxpvASFuulVcqPeltD0qG5s8o/6NMNHe12lRR70UoKXK3Ow1NlpcU2M3bi+fdbabijo1brY+gPqQU+WYAeR8EgnkebKWkB8en2/DCTaDnfYqGsTFIK8cCqWE1lohMWPTbYAWXAj8wnLDtt2K5UOigw4jlQ=
Message-ID: <191fb4ca0708130955l5ee0d263o4e01c4caa96bf811@mail.gmail.com>
Date: Mon, 13 Aug 2007 09:55:30 -0700
From: "Juerg Haefliger" <juergh@gmail.com>
To: "joe@perches.com" <joe@perches.com>
Subject: Re: [PATCH] [159/2many] MAINTAINERS - DME1737 HARDWARE MONITOR DRIVER
Cc: torvalds@linux-foundation.org, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <46bff993.7OEwF3qQrioxyBDU%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46bff993.7OEwF3qQrioxyBDU%joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/12/07, joe@perches.com <joe@perches.com> wrote:
> Add file pattern to MAINTAINER entry
>
> Signed-off-by: Joe Perches <joe@perches.com>
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 70e5070..2fafb83 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1553,6 +1553,7 @@ P:        Juerg Haefliger
>  M:     juergh@gmail.com
>  L:     lm-sensors@lm-sensors.org
>  S:     Maintained

+F:     Documentation/hwmon/dme1737

> +F:     drivers/hwmon/dme1737.c
>
>  DOCBOOK FOR DOCUMENTATION
>  P:     Randy Dunlap
>
