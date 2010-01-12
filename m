Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973Ab0ALQZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab0ALQZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 11:25:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200Ab0ALQZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 11:25:16 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:47042 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab0ALQZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 11:25:15 -0500
Date: Tue, 12 Jan 2010 08:24:26 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for January 12 (backlight warning)
Message-Id: <20100112082426.a8c7b655.randy.dunlap@oracle.com>
In-Reply-To: <20100112171739.2011a0eb.sfr@canb.auug.org.au>
References: <20100112171739.2011a0eb.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B4CA258.01B8:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jan 2010 17:17:39 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100109:


drivers/video/backlight/88pm860x_bl.c:23:1: warning: "CURRENT_MASK" redefined
arch/x86/include/asm/page_64_types.h:6:1: warning: this is the location of the previous definition


---
~Randy
