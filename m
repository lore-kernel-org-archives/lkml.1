Return-Path: <linux-kernel-owner+w=401wt.eu-S1756471AbYEZUdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471AbYEZUdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 16:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289AbYEZUdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 16:33:05 -0400
Received: from mail.suse.de ([195.135.220.2]:42027 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755048AbYEZUdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 16:33:04 -0400
Date: Mon, 26 May 2008 22:32:59 +0200
From: Bernhard Walle <bwalle@suse.de>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: akpm@osdl.org, Sharyathi Nagesh <sharyath@in.ibm.com>, sachinp@in.ibm.com,
       mohd.omar@in.ibm.com, Kexec Mailing List <kexec@lists.infradead.org>,
       fastboot@lists.osdl.org, linux-kernel@vger.kernel.org, mohan@in.ibm.com,
       IndhuDurai@in.ibm.com
Subject: Re: correction to compat_sys_kexec_load
Message-ID: <20080526223259.4d3d2979@kopernikus.site>
In-Reply-To: <m1od6w4jxx.fsf@frodo.ebiederm.org>
References: <4836AC3C.3090005@in.ibm.com>
	<m1ve144w25.fsf@frodo.ebiederm.org>
	<20080523233348.13fe0c63@kopernikus.site>
	<m1od6w4jxx.fsf@frodo.ebiederm.org>
Organization: SUSE LINUX Products GmbH
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* ebiederm@xmission.com (Eric W. Biederman) [2008-05-23 17:36]:
>
> As there is no real justification for it.  At this
> point getting user space fixed so that it works on older kernels
> seems important. 

http://article.gmane.org/gmane.linux.kernel.kexec/1534 should fix this.


