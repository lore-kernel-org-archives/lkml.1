Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbZABQwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbZABQwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 11:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757532AbZABQwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 11:52:25 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:16423 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507AbZABQwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 11:52:21 -0500
Message-ID: <fa686aa40901020852t4f214948n3b4d445f43236e94@mail.gmail.com>
Date: Fri, 2 Jan 2009 09:52:19 -0700
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Paul Mackerras" <paulus@samba.org>
Subject: Re: [PATCH v2] Update powerpc maintainers
Cc: torvalds@linux-foundation.org, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <18781.39639.123017.149165@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <18781.39639.123017.149165@cargo.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 1, 2009 at 9:40 PM, Paul Mackerras <paulus@samba.org> wrote:
> Ben Herrenschmidt is taking over as the primary powerpc architecture
> maintainer.  I'll still be around as his backup/deputy.
>
> Signed-off-by: Paul Mackerras <paulus@samba.org>

Yeah, I *guess* I can follow Ben.  :-P

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
> Now with added tree location update goodness!
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ceb32ee..967b0e8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2635,13 +2635,13 @@ W:      http://www.hansenpartnership.com/voyager
>  S:     Maintained
>
>  LINUX FOR POWERPC (32-BIT AND 64-BIT)
> -P:     Paul Mackerras
> -M:     paulus@samba.org
>  P:     Benjamin Herrenschmidt
>  M:     benh@kernel.crashing.org
> +P:     Paul Mackerras
> +M:     paulus@samba.org
>  W:     http://www.penguinppc.org/
>  L:     linuxppc-dev@ozlabs.org
> -T:     git kernel.org:/pub/scm/linux/kernel/git/paulus/powerpc.git
> +T:     git kernel.org:/pub/scm/linux/kernel/git/benh/powerpc.git
>  S:     Supported
>
>  LINUX FOR POWER MACINTOSH
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
