Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbZAGIKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbZAGIKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 03:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZAGIKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 03:10:46 -0500
Received: from mga06.intel.com ([134.134.136.21]:20635 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751121AbZAGIKp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 03:10:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,225,1231142400"; 
   d="scan'208";a="376327749"
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Organization: Intel Corporation
To: wimax@linuxwimax.org
Subject: Re: linux-next: Tree for January 6 (wimax errs)
Date: Wed, 7 Jan 2009 00:09:57 -0800
User-Agent: KMail/1.9.9
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-wimax@intel.com
References: <20090106182311.525e4b14.sfr@canb.auug.org.au> <20090106132321.8a330942.randy.dunlap@oracle.com> <200901061350.02562.inaky.perez-gonzalez@intel.com>
In-Reply-To: <200901061350.02562.inaky.perez-gonzalez@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901070009.57582.inaky@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 January 2009, Iñaky Pérez-González wrote:
> On Tuesday 06 January 2009, Randy Dunlap wrote:
> > On Tue, 6 Jan 2009 18:23:11 +1100 Stephen Rothwell wrote:
> > > Hi all,
> > >
> > > This tree will not build a powerpc ppc4xx_defconfig due to a kvm
> > > problem.
> > >
> > > Changes since 20090105:
> >
> > wimax build fails when CONFIG_INPUT=n:
>
> Ops -- my fault -- working on a fix.
>
> > Also, this warning needs to be fixed:
> >
> > linux-next-20090106/net/wimax/id-table.c:133: warning: ISO C90 forbids
> > mixed declarations and code
>
> Will fix too.

I just submitted a patchset to gregkh that fixes these issues and just 
realized I didn't CC you guys:

http://linuxwimax.org/pipermail/wimax/2009-January/000397.html

My apologies for missing out,

-- 
Inaky
