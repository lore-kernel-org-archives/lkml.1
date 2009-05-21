Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbZEUABv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbZEUABv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 20:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756422AbZEUABn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 20:01:43 -0400
Received: from web50108.mail.re2.yahoo.com ([206.190.38.36]:48909 "HELO
	web50108.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756397AbZEUABn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 20:01:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=RCb68umTTcppScGCGmB01x1yEBy+derjAFmGfjE1UruFb+HlPCDvC+SehwmtHPyLTuEv5GlCp7TV8hWYnJk5CrnCIy3sLb5tNBqBCzVM7LUstDOE/LYTEa/aoixDrxkFQL/1FLHDVKBbRZhtgoNohxWGL4lN9pkt87ihamlD+AQ=;
Message-ID: <773162.73757.qm@web50108.mail.re2.yahoo.com>
X-YMail-OSG: KB85z18VM1lfVUNxbAa7c8ThuG6QfjjujLqeux8PKX_8WPptz45vAazl40mHDcBArV.ry32ewybvpbrn_4WJ9ttDmxp79tCKiPWO37Fgo8Be93vm3_9QkSTMU6Ze2lwPD0ds7dEh2.9Xda6qQ3jq2TOO6ExPf0RHFcuyuxXADo._RYuNJuc.nqtRQNJih98797ivr6jQLlPJCBzMKdjUEXvlIfJj0iiFq62WPrLn8HM0gD3tdpSQ9Tye3QmG2B4dLMioBSAENNs6NwyYXF9r8Dv9x0cT6jUMHR69S3cjyCz1t7Bm3iZn1Hdn4gwOgYA-
X-Mailer: YahooMailClassic/5.4.6 YahooMailWebService/0.7.289.10
Date: Wed, 20 May 2009 17:01:43 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH 4/4] amd64_edac: add MAINTAINERS entry
To: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu,
       Borislav Petkov <borislav.petkov@amd.com>
Cc: tglx@linutronix.de, hpa@zytor.com, mchehab@redhat.com, aris@redhat.com,
       edt@aei.ca, linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       Borislav Petkov <borislav.petkov@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- On Wed, 5/20/09, Borislav Petkov <borislav.petkov@amd.com> wrote:

> From: Borislav Petkov <borislav.petkov@amd.com>
> Subject: [PATCH 4/4] amd64_edac: add MAINTAINERS entry
> To: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu
> Cc: norsk5@yahoo.com, tglx@linutronix.de, hpa@zytor.com, mchehab@redhat.com, aris@redhat.com, edt@aei.ca, linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, "Borislav Petkov" <borislav.petkov@amd.com>
> Date: Wednesday, May 20, 2009, 12:43 PM
> CC: Doug Thompson <norsk5@yahoo.com>

Acked-by: Doug Thompson <norsk5@yahoo.com>

> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  MAINTAINERS |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2b349ba..1b93ae4 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1961,6 +1961,16 @@ F:   
> Documentation/edac.txt
>  F:    drivers/edac/edac_*
>  F:    include/linux/edac.h
>  
> +EDAC-AMD64
> +P:    Doug Thompson
> +M:    dougthompson@xmission.com
> +P:    Borislav Petkov
> +M:    borislav.petkov@amd.com
> +L:    bluesmoke-devel@lists.sourceforge.net
> (moderated for non-subscribers)
> +W:    bluesmoke.sourceforge.net
> +S:    Supported
> +F:    drivers/edac/amd64_edac*
> +
>  EDAC-E752X
>  P:    Mark Gross
>  P:    Doug Thompson
> -- 
> 1.6.2.4
> 
> 
> 
