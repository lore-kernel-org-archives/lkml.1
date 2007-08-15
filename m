Return-Path: <linux-kernel-owner+w=401wt.eu-S937404AbXHOWqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937404AbXHOWqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 18:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937194AbXHOWpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 18:45:12 -0400
Received: from web50111.mail.re2.yahoo.com ([206.190.39.137]:40031 "HELO
	web50111.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S937211AbXHOWpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 18:45:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=jKjN9358ODV9vRNPvLjHFTo/wY4xtYC1Y34FTfd/vdvU7x4nUZlFUhLHCiQA++NQNH7O0lZ0jj6rmRkG6lDhqNbvQAicn+nWsqeUqcvWHPwqFqZCTn4rY7N53/y14qNzNMdTSgJMElBmnJ8+I/SIH5uZNBtI2bfMa8Tn/r9HLmk=;
X-YMail-OSG: azzCboIVM1lmIk1_MbqOu0fxUSoXuYycI.MrLpJJXFkzFeUjbqlFZ71qRmn4jlU29JOWErWBg.HfgvOt6UdBT5_3.X_87uMqPWRwuqaepVvjfD6bjt4-
Date: Wed, 15 Aug 2007 15:38:28 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Reply-To: dougthompson@xmission.com
Subject: Re: [PATCH] [171/2many] MAINTAINERS - EDAC-CORE
To: joe@perches.com, linux-kernel@vger.kernel.org,
       bluesmoke-devel@lists.sourceforge.net, akpm@linux-foundation.org
In-Reply-To: <46bff9ac.WLlw8+K3hdwRL7yr%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <524594.10224.qm@web50111.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- joe@perches.com wrote:

> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d4325c7..78e5b0c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1662,6 +1662,9 @@ M:	dougthompson@xmission.com
>  L:	bluesmoke-devel@lists.sourceforge.net
>  W:	bluesmoke.sourceforge.net
>  S:	Supported
> +F:	Documentation/drivers/edac/edac.txt
> +F:	drivers/edac/edac_*
> +F:	include/linux/edac.h
>  
>  EDAC-E752X
>  P:	Mark Gross
> 

Acked-by: Doug Thompson <dougthompson@xmission.com>


