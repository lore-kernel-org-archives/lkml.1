Return-Path: <linux-kernel-owner+w=401wt.eu-S1750987AbZFZEBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750987AbZFZEBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 00:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750699AbZFZEBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 00:01:41 -0400
Received: from exchtp08.via.com.tw ([61.66.243.7]:30336 "EHLO
	exchtp08.via.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbZFZEBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 00:01:41 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: CONFIG_FB_VIA made the screen go black
Date: Fri, 26 Jun 2009 12:01:36 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB8097809F4@exchtp03.taipei.via.com.tw>
In-Reply-To: <19f34abd0906181050xe30f581qef43e4fe759fdbd8@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: CONFIG_FB_VIA made the screen go black
Thread-Index: AcnwPm2ScXT/eQGgRfez8niYP7vTegF0wBTw
From: <JosephChan@via.com.tw>
To: <vegard.nossum@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 26 Jun 2009 04:01:38.0001 (UTC) FILETIME=[CDD6A410:01C9F612]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n5Q42Q54027195


> It seems that I was unfortunate and managed to get CONFIG_FB_VIA=y in my config. 
> The result is that during boot, when via_fb loads, the screen goes black. 
> I put CONFIG_FB_VIA=n as the > only change to my config and the screen works again.
> Actually, just before going black, a few lines (I mean pixel rows) would shortly flicker or move up and down the screen.

We will check this later.

> I don't actually have a VIA card:

Is there any idea that you have to ENABLE viafb if you don't have VIA GFX chips?
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
