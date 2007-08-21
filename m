Return-Path: <linux-kernel-owner+w=401wt.eu-S1752035AbXHUT61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbXHUT61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 15:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbXHUT6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 15:58:19 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:53880 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbXHUT6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 15:58:18 -0400
Date: Tue, 21 Aug 2007 21:58:18 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Ismail =?iso-8859-1?q?D=F6nmez?= <ismail@pardus.org.tr>
cc: Hex Star <hexstar@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Trouble booting with new 2.6.22.3 kernel
In-Reply-To: <200708212256.59281.ismail@pardus.org.tr>
Message-ID: <Pine.LNX.4.64.0708212157530.20435@fbirervta.pbzchgretzou.qr>
References: <5dc6fd9e0708211219p679116a4n48765e72e2253ddc@mail.gmail.com>
 <5dc6fd9e0708211226k3f931579x6f8b3ab275f93c35@mail.gmail.com>
 <5dc6fd9e0708211227k22f9e214vd8132913214716b3@mail.gmail.com>
 <200708212256.59281.ismail@pardus.org.tr>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-699020219-182362861-1187726298=:20435"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---699020219-182362861-1187726298=:20435
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


On Aug 21 2007 22:56, Ismail Dönmez wrote:
>On Tuesday 21 August 2007 22:27:25 you wrote:
>> On 8/21/07, Hex Star <hexstar@gmail.com> wrote:
>> > Ah so the IDE/SATA driver should not be a module (if it is a module
>> > it'll cause this issue)?
>>
>> One more thing, are there any other critical kernel components that
>> won't work as a module and thus prevent boot?
>
>Well also the filesystem module for the root fs ( / ) should not be a module 
>as you won't be able mount root at startup hence causing a panic.

- which is why people use initramfs. It's all perfect.

>Perfect is the enemy of good


	Jan
-- 
---699020219-182362861-1187726298=:20435--
