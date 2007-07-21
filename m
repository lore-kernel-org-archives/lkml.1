Return-Path: <linux-kernel-owner+w=401wt.eu-S932678AbXGUTfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678AbXGUTfi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 15:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761632AbXGUTfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 15:35:23 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:45670 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760723AbXGUTfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 15:35:22 -0400
Date: Sat, 21 Jul 2007 21:35:21 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use menuconfig objects - Fusion
In-Reply-To: <Pine.LNX.4.64.0707211513170.6770@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0707212135060.21737@fbirervta.pbzchgretzou.qr>
References: <200705102317.l4ANHrUC001117@shell0.pdx.osdl.net>
 <Pine.LNX.4.64.0707182035080.5385@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0707211501570.5853@localhost.localdomain>
 <Pine.LNX.4.64.0707212112060.21737@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0707211513170.6770@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 21 2007 15:15, Robert P. J. Day wrote:
>> >wouldn't it be philosophically cleaner if the internals of a
>> >menuconfig structure *automatically* depended on selection of the
>> >menuconfig and the "if" part was implicit?
>>
>> "menuconfig" is not a start marker like "menu" was. Hence it has no
>> "stop" marker either. We would need a new object type for that.
>
>http://www.linuxrocket.net/index.cgi?a=MailArchiver&ma=ShowMail&Id=525787

Exactly like that. But kconfig don't have selectablemenu (yet).


	Jan
-- 
