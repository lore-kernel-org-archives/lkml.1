Return-Path: <linux-kernel-owner+w=401wt.eu-S1757123AbXI2SxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123AbXI2SxS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 14:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754940AbXI2SxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 14:53:06 -0400
Received: from smtp120.sbc.mail.re3.yahoo.com ([66.196.96.93]:20711 "HELO
	smtp120.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754904AbXI2SxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 14:53:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=vj+GcP4Sjsudgu01Jl0rZEwT2XFGtLmGh+K2CEjozX9TCGFqaZEe4vmUep/kdimS79XC3+XS+1QQn6l6rs8rF74y5Ym1DpLcwzJqsap/TGY7phVdk4hKNcjnzcN2p7r+W5h1/+OOjT+a3oRj+YQNiFU4jAaoYVj7S9AFEQXmmW0=  ;
X-YMail-OSG: 2xLvh.8VM1lRUC7bxIwX9MeIaABNBHE6ojXtg4Jzzofv6B4L2S.s2ETVjk9mRrs1sA5ehqbCkyiE7sJemoEOJyJ0QSV62mTTrI3gUHPeGMIq4Ckk7Yh1WvuOusi38bl57h2sums0yaf5OA--
Date: Sat, 29 Sep 2007 11:53:06 -0700
From: David Brownell <david-b@pacbell.net>
To: randy.dunlap@oracle.com, akpm@linux-foundation.org
Subject: Re: [PATCH] CodingStyle: Printing numbers in parentheses is fine
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       khali@linux-fr.org
References: <20070929122530.5c45f743@hyperion.delvare>
 <20070929035156.cd6fe860.akpm@linux-foundation.org>
 <20070929112928.56a04641.randy.dunlap@oracle.com>
In-Reply-To: <20070929112928.56a04641.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070929185306.183D72399D7@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From randy.dunlap@oracle.com  Sat Sep 29 11:40:17 2007
>
> Let's kill it, please.  (i.e., ACK)

But ... why?  What value could needless parens provide?
"Yet Another Subtle And Hard To Fix Source Of Bloat" is
not a plus.

I'd kind of think a change like this should have some
positive motivation.

