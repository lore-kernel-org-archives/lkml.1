Return-Path: <linux-kernel-owner+w=401wt.eu-S1753642AbYGAGhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbYGAGhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 02:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbYGAGhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 02:37:34 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:53442 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbYGAGhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 02:37:34 -0400
Date: Tue, 1 Jul 2008 08:37:32 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Tomas M <tomas@slax.org>
cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: LZMA compression algorithm in Kernel - any chance to allow it?
In-Reply-To: <4864F524.2070603@slax.org>
Message-ID: <alpine.LNX.1.10.0807010836540.26892@fbirervta.pbzchgretzou.qr>
References: <48634BA7.6030902@slax.org> <20080626201754.GE9878@ucw.cz> <alpine.LNX.1.10.0806271532150.12725@fbirervta.pbzchgretzou.qr> <4864F524.2070603@slax.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-06-27 16:11, Tomas M wrote:

>Jan Engelhardt wrote:
>> On Thursday 2008-06-26 22:17, Pavel Machek wrote:
>>>> If I (or anybody else) submit LZMA code for inclusion in kernel, would you ACCEPT IT ?? (assuming the code looks nice to you)
>>> You need some good reason why lzma should be in kernel... like 'cramfs
>>> can use it'...?
>> 
>> squashfs if at all.
>> 
>
>Well anything can use lzma or any other compressions, not only squashfs.
>Squashfs is a great example, where you get 30% smaller filesystems compared to gzip.

I rather meant "who would still use cramfs", given that squashfs
actually crams more files into the same space.
