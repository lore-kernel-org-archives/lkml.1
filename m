Return-Path: <linux-kernel-owner+w=401wt.eu-S1752260AbZIINPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbZIINPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 09:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbZIINPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 09:15:07 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:36935 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbZIINPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 09:15:06 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mmc@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: Regression in suspend to ram in 2.6.31-rc kernels
References: <c4e36d110908310451t7c238e09u5af112fa3321cc23@mail.gmail.com>
	<200908312119.12121.rjw@sisk.pl>
	<c4e36d110909010234i5f1b9357l805132137725a4f8@mail.gmail.com>
	<c4e36d110909031529q77b53122kdb85785ba293c478@mail.gmail.com>
	<20090903232317.GA6760@lst.de> <87ljkvmt71.fsf@devron.myhome.or.jp>
	<c4e36d110909040213t4d4258b4w3e2d4725e0b2a161@mail.gmail.com>
	<87iqfx5mss.fsf@devron.myhome.or.jp>
	<c4e36d110909051253s5c5e9d96x3ebdc444231b5776@mail.gmail.com>
	<873a7157zu.fsf@devron.myhome.or.jp>
	<c4e36d110909080110t21dd1402l35bf50360ba0b525@mail.gmail.com>
Date: Wed, 09 Sep 2009 22:15:01 +0900
In-Reply-To: <c4e36d110909080110t21dd1402l35bf50360ba0b525@mail.gmail.com>
	(Zdenek Kabelac's message of "Tue, 8 Sep 2009 10:10:32 +0200")
Message-ID: <87pra05kfe.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zdenek Kabelac <zdenek.kabelac@gmail.com> writes:

> Just a side note - Could be there any connection with my previous report?
>
> http://lkml.org/lkml/2009/8/28/90

As far as I can see, it doesn't seem related problem to this. It seems
mmc's driver problem (or problem of unusual device).

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
