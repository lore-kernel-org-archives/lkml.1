Return-Path: <linux-kernel-owner+w=401wt.eu-S1755637AbZBOTYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbZBOTYw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 14:24:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbZBOTYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 14:24:43 -0500
Received: from web110607.mail.gq1.yahoo.com ([67.195.13.198]:45906 "HELO
	web110607.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752755AbZBOTYn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 14:24:43 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=XvZIrZInSr8fZ5WtljBd0lpEOwd1yd1Eihz3SQaCKzqR35mATpKEMDwAM+0F9V1aJ95aBRqhVbUakK/LRC1c8FaLjGAKn23UVO9plQJfQZL9cY4Qh+vniif13RrErIvgobeh8Dpt8+dIuhTcWgapRt4oXr+ydwWvHUTbLxsy/+Q=;
X-YMail-OSG: ep6B8tUVM1lI_sinq3.XIAb1k8HPWd1ZyyUJ_2crezaBA1e4oCuUjc6RpFJKJUV3yO_4UMdzkzFZer.GeFu3It5JfJH6tbTjv7WCJxh8BSOu4SEEQg9JMJJLJhrPSkNft7ts5CTBVAJWX3svd8mT3K0AqOx1qumVkVOW3ys24jvx3ZhzpYDVDG7wZPAYwMxihFNStsJjLLUaaTOA6dB8lBSogCFVBZky1JLKCCy6QiFJMsw6LVc639tWjtu0
X-Mailer: YahooMailRC/1155.45 YahooMailWebService/0.7.260.1
References: <slrngpgfil.5gc.sitsofe@sitsofe.eeepc.localdomain> <20090215170214.GK5835@nowhere>
Date: Sun, 15 Feb 2009 11:24:41 -0800 (PST)
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: Poking ieee80211_default_rc_algo causes kernel lockups
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <883216.75749.qm@web110607.mail.gq1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Could you please enable the CONFIG_DETECT_SOFTLOCKUP option in your kernel?

> It's on Kernel Hacking > Detect Soft Lockups.
> With some chances you will have a relevant stacktrace of the lockup, in case
> I couldn't reproduce it.

I'll try (the kernel I'm currently using is jam packed with with debug options) but I'm unconvinced it will unfreeze enough for anything useful...



      
