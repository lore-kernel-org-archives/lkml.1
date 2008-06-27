Return-Path: <linux-kernel-owner+w=401wt.eu-S1757851AbYF0OLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851AbYF0OLj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 10:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbYF0OLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 10:11:32 -0400
Received: from ns1.bluetone.cz ([212.158.128.13]:32860 "EHLO ns1.bluetone.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbYF0OLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 10:11:31 -0400
Message-ID: <4864F524.2070603@slax.org>
Date: Fri, 27 Jun 2008 16:11:48 +0200
From: Tomas M <tomas@slax.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: LZMA compression algorithm in Kernel - any chance to allow it?
References: <48634BA7.6030902@slax.org> <20080626201754.GE9878@ucw.cz> <alpine.LNX.1.10.0806271532150.12725@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0806271532150.12725@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Thursday 2008-06-26 22:17, Pavel Machek wrote:
>>> If I (or anybody else) submit LZMA code for inclusion in kernel, would you ACCEPT IT ?? (assuming the code looks nice to you)
>> You need some good reason why lzma should be in kernel... like 'cramfs
>> can use it'...?
> 
> squashfs if at all.
> 

Well anything can use lzma or any other compressions, not only squashfs.
Squashfs is a great example, where you get 30% smaller filesystems compared to gzip.

Tomas M
