Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbXGGU5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbXGGU5R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 16:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbXGGU5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 16:57:07 -0400
Received: from terminus.zytor.com ([192.83.249.54]:38931 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbXGGU5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 16:57:06 -0400
Message-ID: <468FFE18.4000500@zytor.com>
Date: Sat, 07 Jul 2007 13:56:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][Patch] Allow not mounting a root fs
References: <Pine.LNX.4.58.0707060318160.26869@be1.lrz> <468DA42D.7050309@zytor.com> <Pine.LNX.4.64.0707072030230.1536@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0707072030230.1536@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jul 5 2007 19:08, H. Peter Anvin wrote:
>>> BTW: Is it possible to mount a tmpfs on / before extracting the cpio?
>> Not in the stock kernel.  There have been some patches floating around
>> for that, I think.
> 
> What would it buy? rootfs is a tmpfs, is not it?

No, rootfs is ramfs.

	-hpa
