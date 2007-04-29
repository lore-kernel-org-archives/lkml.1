Return-Path: <linux-kernel-owner+w=401wt.eu-S932382AbXD2H7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382AbXD2H7w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 03:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932478AbXD2H7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 03:59:52 -0400
Received: from il.qumranet.com ([82.166.9.18]:58861 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932382AbXD2H7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 03:59:51 -0400
Message-ID: <46345072.4030306@qumranet.com>
Date: Sun, 29 Apr 2007 10:59:46 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] drivers/kvm/mmu.c: fix an if() condition
References: <20070428192048.GX3468@stusta.de>
In-Reply-To: <20070428192048.GX3468@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> It might have worked in this case since PT_PRESENT_MASK is 1, but let's 
> express this correctly.
>
>   

Applied, thanks.


-- 
error compiling committee.c: too many arguments to function

