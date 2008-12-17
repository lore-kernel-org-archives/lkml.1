Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758377AbYLQLOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758377AbYLQLOV (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 06:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbYLQLOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 06:14:09 -0500
Received: from exchtp08.via.com.tw ([61.66.243.7]:64901 "EHLO
	exchtp08.via.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbYLQLOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 06:14:08 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [Patch 3/3] via-sdmmc: via-sdmmc.h
Date: Wed, 17 Dec 2008 19:14:06 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB808521884@exchtp03.taipei.via.com.tw>
In-Reply-To: <200812161325.58594.arnd@arndb.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Patch 3/3] via-sdmmc: via-sdmmc.h
Thread-Index: AclfeXr+JpPLQAhQQrKlFbs4DZARIAAvvojw
From: <JosephChan@via.com.tw>
To: <arnd@arndb.de>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 17 Dec 2008 11:14:07.0724 (UTC) FILETIME=[942DE2C0:01C96038]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by imap1.linux-foundation.org id mBHBGYh3021785

> > 
> 
> The order of your patches is reversed, you add the 
> Kconfig/Makefile changes last so that the tree stays 
> 'bisectable', i.e. you don't have a broken build in the 
> middle between your patches.
> 
> Since your header file is not an interface but only used in a 
> single source file, I would also suggest merging it into the 
> main via-sdmmc.c file, add changing Kconfig/Makefile in the 
> same patch.
> 
> 	Arnd <><
> 

Tks, I'll notice this next time.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
