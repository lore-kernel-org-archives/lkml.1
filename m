Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbZBOOAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbZBOOAd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 09:00:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbZBOOAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 09:00:19 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:43545 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbZBOOAQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 09:00:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=UX3pseAJe4mwfvF/pi1adJMU69yEm36uIQaiYmDXSkE52Yy14r1dRsLdYmCUKvlgsM
         JMJKSgIWoS7iFc3Fj70a4DVUxbWvxvQyIC0sqPo0oDjLuEw3TX7RLF13UvIbaHTGNjm6
         1/EYQRj0E30jAzyiMJIm+L2uaWg3K9PWfmniQ=
From: Florian Fainelli <florian@openwrt.org>
To: Hannes Eder <hannes@hanneseder.net>
Subject: Re: [PATCH 09/43] drivers/net/r6040.c: fix sparse warning: Using plain integer as NULL pointer
Date: Sun, 15 Feb 2009 15:00:06 +0100
User-Agent: KMail/1.9.9
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net> <20090214211400.23489.24726.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090214211400.23489.24726.stgit@vmbox.hanneseder.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902151500.06516.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Hannes,

Le Saturday 14 February 2009 22:14:04 Hannes Eder, vous avez écrit :
> Fix this sparse warnings:
>   drivers/net/r6040.c:487:31: warning: Using plain integer as NULL pointer
>   drivers/net/r6040.c:492:31: warning: Using plain integer as NULL pointer

Good catch, thanks.
>
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Acked-by: Florian Fainelli <florian@openwrt.org>
-- 
Best regards, Florian Fainelli
Email : florian@openwrt.org
http://openwrt.org
-------------------------------
