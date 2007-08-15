Return-Path: <linux-kernel-owner+w=401wt.eu-S934606AbXHOWox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934606AbXHOWox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 18:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937088AbXHOWnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 18:43:23 -0400
Received: from web50111.mail.re2.yahoo.com ([206.190.39.137]:37822 "HELO
	web50111.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S936636AbXHOWnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 18:43:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=2K77OGk6WsS/6acGFjL+xSlOW1tYED0p7MJfWolZaFiumNJ8e2QkhDKcIMHRTnlwQNBGUwPE8ifW3Xfk+wQWEbtroVDowGppqVPzgG2Cy6tmWdrP5FS0witMoyM5Ll7mBy8ujDZDyhn/qGL3F9klTe17pAcg0yFDzmZKgtpa1wg=;
X-YMail-OSG: gR0FKEcVM1ni5sAcRcrenv8IThJNixXATpQi2sr397dStMOVsNZbwgPBxurYEAhwMwgkedmUovshqy1E6bcd5CBqUbXh9JQd1RtkhCt911p3TMMJdk.9BPxMJKi1FG_UYhLNMar_5l3FgMY-
Date: Wed, 15 Aug 2007 15:36:39 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Reply-To: dougthompson@xmission.com
Subject: Re: [PATCH] [175/2many] MAINTAINERS - EDAC-I5000
To: joe@perches.com, linux-kernel@vger.kernel.org, dougthompson@xmission.com,
       bluesmoke-devel@lists.sourceforge.net, akpm@linux-foundation.org
In-Reply-To: <46bff9b3.1QuIhv0X2zL8aBq8%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <557193.9283.qm@web50111.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- joe@perches.com wrote:

> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c26b346..c2ef686 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1705,6 +1705,7 @@ M:	dougthompson@xmission.com
>  L:	bluesmoke-devel@lists.sourceforge.net
>  W:	bluesmoke.sourceforge.net
>  S:	Maintained
> +F:	drivers/edac/i5000_edac.c
>  
>  EDAC-I82975X
>  P:	Ranganathan Desikan
> 

Acked-by: Doug Thompson <dougthompson@xmission.com>

