Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbXELDFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbXELDFI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 23:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbXELDE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 23:04:58 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:14745 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbXELDE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 23:04:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dxydINR1aspcYB4TTp24CuAmD/mezJWUyOaLEPEusrO1GfqWQjuGJx8SNA0awXhuua9vt/EFZYkKZrd9Za6179UMELCVGRoxFMzN6jsl6sppmCyDeZmHqiQjLbbmsl4r8O7LQoj/EPe9mXib30pjqwamrmrp+cPLhf73/ImWPws=
Message-ID: <a781481a0705112004y2e5ef9e3icaa6972e7afbb96f@mail.gmail.com>
Date: Sat, 12 May 2007 08:34:56 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Simon Arlott" <simon@fire.lp0.eu>
Subject: Re: [PATCH] spelling fixes: init/
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
In-Reply-To: <4644C7AE.4000108@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4644C7AE.4000108@simon.arlott.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/12/07, Simon Arlott <simon@fire.lp0.eu> wrote:
> Spelling fix in init/.
>
> Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
> ---
>  init/main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/init/main.c b/init/main.c
> index e8d080c..7ee2031 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -275,7 +275,7 @@ static int __init unknown_bootoption(char *param, char *val)
>                 return 0;
>
>         /*
> -        * Preemptive maintenance for "why didn't my mispelled command
> +        * Preemptive maintenance for "why didn't my misspelled command
>          * line work?"

That was probably intentional.
