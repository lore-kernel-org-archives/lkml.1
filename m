Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546AbXJ3LC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbXJ3LC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 07:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbXJ3LBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 07:01:16 -0400
Received: from mx0.towertech.it ([213.215.222.73]:33460 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753098AbXJ3LBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 07:01:15 -0400
Date: Tue, 30 Oct 2007 11:59:50 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com, Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [rtc-linux] [PATCH] rtc: m48t59 fix section mismatch warning
Message-ID: <20071030115950.4a149cb3@i1501.lan.towertech.it>
In-Reply-To: <20071029112004.de52d9db.randy.dunlap@oracle.com>
References: <20071029112004.de52d9db.randy.dunlap@oracle.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007 11:20:04 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Change the name of this data to use a name (suffix) that is whitelisted
> by MODPOST so that the section warning is fixed (not generated).
> 
> WARNING: vmlinux.o(.data+0x1b140): Section mismatch: reference to .init.text:m48t59_rtc_probe (between 'm48t59_rtc_platdrv' and 'm48t59_nvram_attr')
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

 Thanks Randy!


 Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

