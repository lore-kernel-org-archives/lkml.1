Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab0AOCHw (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 21:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791Ab0AOCHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 21:07:51 -0500
Received: from web37605.mail.mud.yahoo.com ([209.191.87.88]:21758 "HELO
	web37605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751279Ab0AOCHu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 21:07:50 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jan 2010 21:07:50 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=A/SoOV1MT2qRrspR3i9pyFy3b8ukx6/EAJ0dvxPLUFfbKWn4Qjct8peqvt+DqrknQNDYklyUnu0DO1skTlDhNW0UX0Zbv823iOtYY96nJDaNQNxqu+pOSrsE0o+weuH6MIcMDPOjvzBuHyUErRQYcNgZzTumDZInF4aHjP8ARKg=;
Message-ID: <507734.29595.qm@web37605.mail.mud.yahoo.com>
X-YMail-OSG: f78ugv0VM1nRyD_08sQZX6X7E25j01Yon2IKkVvbMlfRRUWo73IsnX5Ld3GJ7P5xtgeUDo42tjl_MpGDTCvM4AhmFM8ZF8ah8cY6By8iI1RxIdGsKuxlMLU4xf5DnU10YV4hYW3G4snnV.O7_oKSHrjf1rF80SuiUgkf.QpjKfkwurfBScDvKgxNrqgtFr3qAy_yc3Od1hw7rzNyxWrUN4DThwB55pAckEVQ41WUBUm0m7uZqaf8wFhLc7jnYxwpzg6IpNNIhqxTQsSkkcVq9V9xTxeltsTsXJ0LAegAf3wd3SQCAnJs0_YLMohb6qE6I5AoPp1FpDlUbqK5h7bMljQKroOO3S0bb111gIhgMfF3CF0HLl43md_MQ.wodwQqXgDFXh46MyjxWxXb00hb2Hu3a1OM_nYSX1biSK.Tok5d0sXSw857VsGmsiGn1IS8WssbUQeih.bXFnORL.d4y6M-
X-Mailer: YahooMailClassic/9.0.20 YahooMailWebService/0.8.100.260964
Date: Thu, 14 Jan 2010 18:01:08 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: RFC: [PATCH V3 0/9 Integration of SmartMedia/xD into mtd subsystem
To: linux-kernel <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-mtd <linux-mtd@lists.infradead.org>, joern <joern@logfs.org>
In-Reply-To: <1263511637.4780.4.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > Still bear in mind that FTL can destroy data,
> especially if your flash
> > card is worn out.

I sort of worry about this particular issue.

When I was doing my FTL, handling of bad blocks was one
of the major (if not the primary) implementation problems.



      __________________________________________________________________________________
See what's on at the movies in your area. Find out now: http://au.movies.yahoo.com/session-times/
