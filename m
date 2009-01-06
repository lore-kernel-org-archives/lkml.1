Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbZAFVuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbZAFVuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 16:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbZAFVuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 16:50:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:58046 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349AbZAFVui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 16:50:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,221,1231142400"; 
   d="scan'208";a="420184455"
From: =?utf-8?q?I=C3=B1aky_P=C3=A9rez-Gonz=C3=A1lez?= 
	<inaky.perez-gonzalez@intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for January 6 (wimax errs)
Date: Tue, 6 Jan 2009 13:50:02 -0800
User-Agent: KMail/1.9.9
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-wimax@intel.com,
       wimax@linuxwimax.org
References: <20090106182311.525e4b14.sfr@canb.auug.org.au> <20090106132321.8a330942.randy.dunlap@oracle.com>
In-Reply-To: <20090106132321.8a330942.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901061350.02562.inaky.perez-gonzalez@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 January 2009, Randy Dunlap wrote:
> On Tue, 6 Jan 2009 18:23:11 +1100 Stephen Rothwell wrote:
> > Hi all,
> >
> > This tree will not build a powerpc ppc4xx_defconfig due to a kvm problem.
> >
> > Changes since 20090105:
>
> wimax build fails when CONFIG_INPUT=n:

Ops -- my fault -- working on a fix.

> Also, this warning needs to be fixed:
>
> linux-next-20090106/net/wimax/id-table.c:133: warning: ISO C90 forbids
> mixed declarations and code

Will fix too.

Thanks Randy,
