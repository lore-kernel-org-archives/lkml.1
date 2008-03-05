Return-Path: <linux-kernel-owner+w=401wt.eu-S1761370AbYCERH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761370AbYCERH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 12:07:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760251AbYCERHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 12:07:46 -0500
Received: from web52009.mail.re2.yahoo.com ([206.190.48.58]:41119 "HELO
	web52009.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754689AbYCERHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 12:07:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=3e0jh4dnVy4tQTVQEqQCg5syHHj+jxveRxouZrCjNkarHI6zJGMSMSOJU9inCmK84/IkU9f1A36mgD+4gYsRMk62Lt9S6sbOVJiQ5OXc74VCyBJZuWOjZUPNHxWd2umY8yCXZF6oFueHwqTCmJlghBx5xWx0bunMPgsBg/nK9no=;
X-YMail-OSG: JDd5XC8VM1kY3Mx8j4qzmme_aiCgwZGIxW3KBzHn4pQP7Owij6lBGovEGGZRHTXW.cDRvIHsCFrrMvihqiaRRKsoL7.B8iVx06X2G0w4l6irHvRcV_URTlAJkQU_KWLvK3hal3JiabT.OhQ-
X-Mailer: YahooMailRC/902.35 YahooMailWebService/0.7.162
Date: Wed, 5 Mar 2008 09:07:43 -0800 (PST)
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Subject: Re: [patch] Re: using long instead of atomic_t when only set/read is required
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <64659.5446.qm@web52009.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-03 at 18:24 +0100, Pavel Machek wrote:
> "For all properly-aligned pointer and integral types other than short or
> long long..."

As far as I know, Linux kernel supports Alpha that does not have atomic
updates of integral types with less than 32 bits.


      ____________________________________________________________________________________
Looking for last minute shopping deals?  
Find them fast with Yahoo! Search.  http://tools.search.yahoo.com/newsearch/category.php?category=shopping
