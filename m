Return-Path: <linux-kernel-owner+w=401wt.eu-S1759280AbZFVVQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280AbZFVVQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 17:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758849AbZFVVPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 17:15:55 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:55300 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758130AbZFVVPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 17:15:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:content-type
         :content-transfer-encoding:message-id;
        b=TclNPYMH83PrA+xvM1ndZdMLINvDdGtIwqsQe26amYdUlxyvlx3RivAwwGRs0RA3Qn
         c5RNsu//vMWyM/X1BwgZH6oSR/5odp4RgLrhyKSO/eyX0RHax9K2x804fzlbn8Kz8/b/
         Y7X2O2qDGlHwX1W/o38DHAkKyRxpih1pS+tMk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT]: IDE fixes
Date: Mon, 22 Jun 2009 23:20:45 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090619-10934-gace1e80-dirty; KDE/4.2.3; i686; ; )
Cc: David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20090622.024216.03098051.davem@davemloft.net> <alpine.LFD.2.01.0906221039150.3240@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906221039150.3240@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906222320.46718.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 June 2009 19:40:22 Linus Torvalds wrote:
> 
> I really don't want to take this. I think you and Bartlomiej should spend 
> a _lot_ more time and effort trying to resolve this. Me taking it just 
> closes the doors for trying to be constructive about issues.

While this change may come as a surprise to many people I really think
that it moves things forward and that David is the right person to take
over.

I consider his handling of other trees to be top notch and by not being
IDE/libata person he has the needed objectiveness w.r.t. to the current
state of affairs in the both subsystems.

Moreover since David happens to be affiliated with the same company that
stands behind libata he will be more than careful to handle things on
the technical basis with taking interest of all users as a top priority.

I'm still around (same goes for all other major IDE people, though Sergei
seems to be on vacation at the moment ;) and I have already declared
the willingness to help in making the change as painless as possible for
all parties involved.
