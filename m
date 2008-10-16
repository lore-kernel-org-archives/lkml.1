Return-Path: <linux-kernel-owner+w=401wt.eu-S1757426AbYJPVCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426AbYJPVCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 17:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbYJPVB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 17:01:59 -0400
Received: from xenotime.net ([66.160.160.81]:44100 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755071AbYJPVB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 17:01:58 -0400
Date: Thu, 16 Oct 2008 14:01:48 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: linux-kernel@vger.kernel.org
cc: linux-mm@kvack.org
Subject: Re: mmotm 2008-10-16-00-52 uploaded (cgroup + mm)
In-Reply-To: <200810160758.m9G7wZmt018529@imap1.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0810161400230.14604@shark.he.net>
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


build-r9168.out:(.text+0x261e6): undefined reference to `lookup_page_cgroup'
build-r9168.out:memcontrol.c:(.text+0x2629f): undefined reference to `lookup_page_cgroup'
build-r9168.out:memcontrol.c:(.text+0x2671a): undefined reference to `lookup_page_cgroup'
build-r9168.out:(.text+0x268f9): undefined reference to `lookup_page_cgroup'
build-r9168.out:memcontrol.c:(.text+0x26e52): undefined reference to `page_cgroup_init'
build-r9168.out:(.text+0x26f44): undefined reference to `lookup_page_cgroup'
build-r9168.out:(.init.text+0xe42): undefined reference to `pgdat_page_cgroup_init'


.config is at http://oss.oracle.com/~rdunlap/kerneltest/configs/config-r9168

-- 
~Randy
