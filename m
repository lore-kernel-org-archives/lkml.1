Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbYBLWhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbYBLWhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 17:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbYBLWhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 17:37:23 -0500
Received: from mail.syneticon.net ([213.239.212.131]:46505 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbYBLWhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 17:37:22 -0500
Message-ID: <47B21F9A.8040904@wpkg.org>
Date: Tue, 12 Feb 2008 23:37:14 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Cc: wferi@niif.hu
Subject: Re: currently active Linux kernel versions
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wagner Ferenc wrote:

> which are the "currently active Linux kernel versions" at any point in
> time?  The quote is taken from http://lkml.org/lkml/2008/2/11/29.
> Or more precisely: which are the "stable" versions I can depend on for
> a more or less critical server, those that have active security
> support or receive at least critical bugfixes?  I know about the
> 2.6.2[34].y stable git trees, but I wonder how long will those receive
> attention (that is, security fixes).  Can I find a written policy
> somewhere?

I would say:

a) the kernel your distro provides,
b) if you're not using a kernel provided by your distribution, the 
newest kernel from kernel.org (there are some older, still maintaned 
kernels with security fixes, too).


-- 
Tomasz Chmielewski
http://wpkg.org

