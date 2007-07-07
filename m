Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbXGGVNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbXGGVNt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 17:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbXGGVNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 17:13:41 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:17435 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbXGGVNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 17:13:41 -0400
Date: Sat, 7 Jul 2007 23:13:40 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][Patch] Allow not mounting a root fs
In-Reply-To: <468FFE18.4000500@zytor.com>
Message-ID: <Pine.LNX.4.64.0707072312380.1536@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.58.0707060318160.26869@be1.lrz> <468DA42D.7050309@zytor.com>
 <Pine.LNX.4.64.0707072030230.1536@fbirervta.pbzchgretzou.qr>
 <468FFE18.4000500@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 7 2007 13:56, H. Peter Anvin wrote:
>Jan Engelhardt wrote:
>> On Jul 5 2007 19:08, H. Peter Anvin wrote:
>>>> BTW: Is it possible to mount a tmpfs on / before extracting the cpio?
>>> Not in the stock kernel.  There have been some patches floating around
>>> for that, I think.
>> 
>> What would it buy? rootfs is a tmpfs, is not it?
>
>No, rootfs is ramfs.

Thanks for clarifying. Well, why is it a ramfs, and not tmpfs?
(I think I know the difference, but the question stands.
A system without any swap somewhat equals a ramfs, or?)


	Jan
-- 
