Return-Path: <linux-kernel-owner+w=401wt.eu-S1755356AbYFBEl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbYFBEl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 00:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbYFBElu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 00:41:50 -0400
Received: from mga06.intel.com ([134.134.136.21]:37261 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751094AbYFBElt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 00:41:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,576,1204531200"; 
   d="scan'208";a="287017381"
Subject: Re: [Bug #10634] volanoMark regression with kernel 2.6.26-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <20080531190247.GA4569@linux.vnet.ibm.com>
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik>
	 <UJSav77TyUB.A.Z8F.ltZQIB@albercik>
	 <20080531190247.GA4569@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 02 Jun 2008 12:37:59 +0800
Message-Id: <1212381479.3177.260.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-06-01 at 00:32 +0530, Dhaval Giani wrote:
> On Sat, May 31, 2008 at 07:48:05PM +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10634
> > Subject		: volanoMark regression with kernel 2.6.26-rc1
> > Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> > Date		: 2008-05-06 2:06 (26 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121003968414287&w=2
> > Handled-By	: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> > 		  Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> > 		  Ingo Molnar <mingo@elte.hu>
> > 		  Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Patch		: http://marc.info/?l=linux-kernel&m=121015292616788&w=2
> > 
> 
> Should have been fixed with 6363ca57c76b7b83639ca8c83fc285fa26a7880e
> 
> Yanmin, could you confirm please?
Confirmed.

-yanmin

