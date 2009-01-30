Return-Path: <linux-kernel-owner+w=401wt.eu-S1757563AbZA3Dlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbZA3Dlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 22:41:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbZA3DlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 22:41:23 -0500
Received: from mga05.intel.com ([192.55.52.89]:51038 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751022AbZA3DlX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 22:41:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,348,1231142400"; 
   d="scan'208";a="426690426"
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Organization: Intel Corporation
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] wimax: fix build issue when debugfs is disabled
Date: Thu, 29 Jan 2009 19:41:15 -0800
User-Agent: KMail/1.9.9
Cc: randy.dunlap@oracle.com, wimax@linuxwimax.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       toralf.foerster@gmx.de
References: <200901291346.16906.inaky@linux.intel.com> <498228D1.7000105@oracle.com> <20090129.171921.70358850.davem@davemloft.net>
In-Reply-To: <20090129.171921.70358850.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901291941.16074.inaky@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 January 2009, David Miller wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> Date: Thu, 29 Jan 2009 14:08:17 -0800
>
> > Inaky Perez-Gonzalez wrote:
> > > As reported by Toralf Förster and Randy Dunlap.
> > >
> > > - http://linuxwimax.org/pipermail/wimax/2009-January/000460.html
> > >
> > > - http://lkml.org/lkml/2009/1/29/279
> >
> > Thanks.  That one builds.
>
> Applied, thanks everyone.
>
> Inaky, please CC: netdev on your patches in the future.  Otherwise
> they don't get remembered in patchwork and this screws up my entire
> workflow :-/

I will do -- sorry for the oversight.

-- 
Inaky
