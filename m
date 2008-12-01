Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbYLAL0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbYLAL0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 06:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbYLALZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 06:25:50 -0500
Received: from web15703.mail.cnb.yahoo.com ([202.165.102.70]:28269 "HELO
	web15703.mail.cnb.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751251AbYLALZu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 06:25:50 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Dec 2008 06:25:49 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.cn;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=f/4lFgjV1xD6vbxSjfm6wNGBO2mx2KdMT2lIdB0ep3cU6iHAmOidbUqgRmSZOZevY9ESgTKnJnM/dsfhCZJChPalADHuLJtwPGPsDYnnmiu9ThUYMcXpHjaLv1gSbIxlvCRa5rvB4ZhdqoQMhBKQDikc9pHmS0VCDCiQnICWqBE=;
X-YMail-OSG: Jo7Sp.kVM1mce3NGRPGCyrdY7sVI5.zBqcu.wKm54p4ViRO714Krf_tkCRtmjo1PqwY2CDX_JpDJCSEduFikTbOubEn.2gJ2hKWPUmCkN7ip.Z3MVTvxpxeyh6alYuo2CsP6ibYoj9jWv3pFKtMtyVpbBqaeGBu5PYRSAy2y8u5wziU-
X-Mailer: YahooMailWebService/0.7.260.1
Date: Mon, 1 Dec 2008 19:19:07 +0800 (CST)
From: peter meng <mengsanshui@yahoo.com.cn>
Reply-To: mengsanshui@yahoo.com.cn
Subject: I want to know how to write a lcd driver with spi interface
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: 8BIT
Message-ID: <173589.37422.qm@web15703.mail.cnb.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. I want to know how to write a lcd driver with spi interface on
  linux(2.6.24) ? I'm using a tft-lcd(FT-G128160UTSW-123W-E  vendor --TRULY)
  with  s6d0151(IC) that connected to s3c2412 with spi    .
  interface : SDI --> GPG6  WR-->GPG7 CSB -->GPG3 RS-->GPB1 RESET -->GPB2 )

2.How the framebuffer related with spi interface ? I mean how the
  framebuffer know it transfer the data with spi interfcae not the
  RGB/80-System interface.

3. Where i can get the example driver on linux ?


Thanks advanced .
Best Regards .
peter meng 


      ___________________________________________________________ 
  好玩贺卡等你发，邮箱贺卡全新上线！ 
http://card.mail.cn.yahoo.com/
