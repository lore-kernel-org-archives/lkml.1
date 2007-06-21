Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbXFULf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbXFULf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 07:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbXFULfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 07:35:52 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:10341 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbXFULfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 07:35:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:openpgp:content-type:content-transfer-encoding;
        b=cd14SoFrq6XbOWHCsNgnj2TTAC8J0ohLd+23RwjcP5oE7IbuXmh7+LkyIOYJC501hkU8qygX+cm5TXauqkdYR56Q0fQXdnBQ69PPwM1wRWNeQnQ/Mb52pa40FNsQuDZnlAmkio9kWczfgyx9sfphERNHnZ+tuimqNZztz8VXRso=
Message-ID: <467A6290.80602@gmail.com>
Date: Thu, 21 Jun 2007 17:05:44 +0530
From: jimmy bahuleyan <knight.camelot@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Alexandre Oliva <aoliva@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: how about mutual compatibility between Linux's GPLv2 and GPLv3?
References: <orlkedpryc.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <orlkedpryc.fsf@oliva.athome.lsd.ic.unicamp.br>
X-Enigmail-Version: 0.95.1
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexandre Oliva wrote:
> Here's an idea that just occurred to me, after all the discussions
> about motivations, tit-for-tat, authors' wishes and all.
> 
> If GPLv3 were to have a clause that permitted combination/linking with
> code under GPLv2, this wouldn't be enough for GPLv3 projects to use
> Linux code, and it wouldn't be enough for Linux code to use GPLv3
> projects.  That's because GPLv2 would still demand all code to be
> licensed under GPLv2, and GPLv3 wouldn't permit this.
> 
> However, if GPLv3 had a permission to combine/link with code under
> GPLv2, *and* Linux (and any other projects interested in mutual
> compatibility) introduced an additional permission to combine/link
> with code under GPLv3 (or even GPLv3+, constrained by some condition
> if you will), then:
> 

There, that right there, wouldn't it again require a 'nod' from all
those who have contributed to the kernel (because at the time they did,
the license was GPLv2 without any additions)?

-jb
-- 
Tact is the art of making a point without making an enemy.
