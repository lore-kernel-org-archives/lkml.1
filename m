Return-Path: <linux-kernel-owner+w=401wt.eu-S936724AbXHOWfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936724AbXHOWfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 18:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765040AbXHOWfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 18:35:03 -0400
Received: from web50101.mail.re2.yahoo.com ([206.190.38.29]:33778 "HELO
	web50101.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1763275AbXHOWfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 18:35:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=b+zfUOESXCNBM0Kk76XSXBZhlG5XnDeDrseB6lJLc8638mi+lq/V7ctLJe158gOoYsdjg/SCmE4GpRH1ZN9uWwBpoCJX2bJkHwEdfWZSRtKx13ZPJSFTxpgNK/kzFQtqOyGYx5f5vQAFptQZRGIRKb1cuTLyW17N1ge01yU3hnk=;
X-YMail-OSG: IccfliwVM1nCWw4lqSnuPgHMMVHh_ntAGsSGt1pcOX7AnsSvMpyxYGhfS3fXEV1fQAyuoUEiJo4vr4jluYhgLg5Aj7waKh_6fEWhv3tfL0eSnIuwwyjubjjPDjkfE7d9s3I5OA--
Date: Wed, 15 Aug 2007 15:34:55 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Reply-To: dougthompson@xmission.com
Subject: Re: [PATCH] [178/2many] MAINTAINERS - EDAC-R82600
To: joe@perches.com, tim@buttersideup.com, linux-kernel@vger.kernel.org,
       bluesmoke-devel@lists.sourceforge.net, akpm@linux-foundation.org
In-Reply-To: <46bff9b9.HAJkCMlvUhEYWH8+%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <34545.75347.qm@web50101.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- joe@perches.com wrote:

> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 08e62f1..84f6f6b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1731,6 +1731,7 @@ M:	tim@buttersideup.com
>  L:	bluesmoke-devel@lists.sourceforge.net
>  W:	bluesmoke.sourceforge.net
>  S:	Maintained
> +F:	drivers/edac/r82600_edac.c

Acked-by: Doug Thompson <dougthompson@xmission.com>

>  
>  EEPRO100 NETWORK DRIVER
>  P:	Andrey V. Savochkin
> 
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Splunk Inc.
> Still grepping through log files to find problems?  Stop.
> Now Search log events and configuration files using AJAX and a browser.
> Download your FREE copy of Splunk now >>  http://get.splunk.com/
> _______________________________________________
> bluesmoke-devel mailing list
> bluesmoke-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/bluesmoke-devel
> 

