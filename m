Return-Path: <linux-kernel-owner+w=401wt.eu-S964865AbXCLCyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964865AbXCLCyU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 22:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964845AbXCLCyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 22:54:20 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:12592 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964838AbXCLCyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 22:54:19 -0400
Date: Mon, 12 Mar 2007 10:52:22 +0800
From: Joe Jin <joe.jin@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Jin <joe.jin@oracle.com>, James.Bottomley@SteelEye.com,
       dgilbert@interlog.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, haobo.zhou@oracle.com
Subject: Re: [PATCH] [scsi]: Add offline state checking while dispatch a scsi cmd
Message-ID: <20070312025222.GC32372@joejin-pc.cn.oracle.com>
References: <20070308092207.GA17141@joejin-pc.cn.oracle.com> <1173369759.3683.1.camel@mulgrave.il.steeleye.com> <20070309014040.GA6632@joejin-pc.cn.oracle.com> <20070311015300.271c2323.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070311015300.271c2323.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The 2.6.9 base is very old in mainline terms.  Are you sure the bug hasn't
> been fixed in mainline by other means?

I cannot confirm if it have fixed in latest kernel, the server is a
production system, it's hard to debug it and try reproduce.

