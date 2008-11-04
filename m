Return-Path: <linux-kernel-owner+w=401wt.eu-S1753652AbYKDOLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbYKDOLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 09:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbYKDOLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 09:11:09 -0500
Received: from mail-gx0-f31.google.com ([209.85.217.31]:59825 "EHLO
	mail-gx0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbYKDOLI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 09:11:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=ntOthYqU7TnuDaa/ryBOXwsXs/HEiPpkxek6U7KNkEZMuJMcE2WGjKodgayXeUwnby
         Epb3cHjYx74c38W2c90l+J43L3y3shdr3v8T/4EkzD7BmcZU187YTUbGak68EquUleZI
         NXbvcmUcmcZaWg4I4RDanL96NuHBcV4lX5kdI=
Message-ID: <b0438a630811040611x3f442a91y7f267c940fdcf313@mail.gmail.com>
Date: Tue, 4 Nov 2008 15:11:05 +0100
From: "=?ISO-8859-1?Q?Miguel_=C1ngel_=C1lvarez?=" <gotzoncabanes@gmail.com>
To: "Imre Kaloz" <kaloz@openwrt.org>, "Karl Hiramoto" <karl@hiramoto.org>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: MMC/SD, SPI and IXP4XX
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi to all.

I have done some work to add SPI and MMC using SPI to IXP4XX. I have
to do some rework to prepare quality patches, but I would like to ask:
- Is it enough interesting to follow with it?
- Is it already done (openwrt or so)?
- My work is based in the code for PXA2XX. Should I separate it
completely, or try to reuse the code?

Thanks

Miguel Ángel Álvarez
