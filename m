Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbXGGSax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbXGGSax (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 14:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbXGGSao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 14:30:44 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:22741 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbXGGSan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 14:30:43 -0400
Date: Sat, 7 Jul 2007 20:30:42 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][Patch] Allow not mounting a root fs
In-Reply-To: <468DA42D.7050309@zytor.com>
Message-ID: <Pine.LNX.4.64.0707072030230.1536@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.58.0707060318160.26869@be1.lrz> <468DA42D.7050309@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 5 2007 19:08, H. Peter Anvin wrote:
>
>> BTW: Is it possible to mount a tmpfs on / before extracting the cpio?
>
>Not in the stock kernel.  There have been some patches floating around
>for that, I think.

What would it buy? rootfs is a tmpfs, is not it?


	Jan
-- 
