Return-Path: <linux-kernel-owner+w=401wt.eu-S1759837AbZA3BTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759837AbZA3BTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 20:19:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbZA3BTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 20:19:24 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46174
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754525AbZA3BTX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 20:19:23 -0500
Date: Thu, 29 Jan 2009 17:19:21 -0800 (PST)
Message-Id: <20090129.171921.70358850.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: inaky@linux.intel.com, wimax@linuxwimax.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, toralf.foerster@gmx.de
Subject: Re: [PATCH] wimax: fix build issue when debugfs is disabled
From: David Miller <davem@davemloft.net>
In-Reply-To: <498228D1.7000105@oracle.com>
References: <200901291346.16906.inaky@linux.intel.com>
	<1233266369-16834-1-git-send-email-inaky@linux.intel.com>
	<498228D1.7000105@oracle.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Thu, 29 Jan 2009 14:08:17 -0800

> Inaky Perez-Gonzalez wrote:
> > As reported by Toralf Förster and Randy Dunlap.
> > 
> > - http://linuxwimax.org/pipermail/wimax/2009-January/000460.html
> > 
> > - http://lkml.org/lkml/2009/1/29/279
> 
> Thanks.  That one builds.

Applied, thanks everyone.

Inaky, please CC: netdev on your patches in the future.  Otherwise
they don't get remembered in patchwork and this screws up my entire
workflow :-/
