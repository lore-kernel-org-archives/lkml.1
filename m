Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbYJPUi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbYJPUi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 16:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbYJPUiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 16:38:18 -0400
Received: from xenotime.net ([66.160.160.81]:49000 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752259AbYJPUiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 16:38:17 -0400
Date: Thu, 16 Oct 2008 13:38:13 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: linux-kernel@vger.kernel.org
cc: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: mmotm 2008-10-16-00-52 uploaded
In-Reply-To: <200810160758.m9G7wZmt018529@imap1.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0810161336510.14604@shark.he.net>
References: <200810160758.m9G7wZmt018529@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008, akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2008-10-16-00-52 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> It contains the following patches against 2.6.27:


build-r9169.out:ksysfs.c:(.text+0x1a773): undefined reference to `create_proc_profile'

when CONFIG_PROC_FS=n and CONFIG_SYSFS=n

-- 
~Randy
