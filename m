Return-Path: <linux-kernel-owner+w=401wt.eu-S1752651AbZIHX4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbZIHX4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 19:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbZIHX4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 19:56:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:8602 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbZIHX4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 19:56:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,355,1249282800"; 
   d="scan'208";a="491700247"
Subject: Re: [Bug #13819] system freeze when switching to console
From: reinette chatre <reinette.chatre@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, "Ma, Ling" <ling.ma@intel.com>,
       "bugzilla-daemon@bugzilla.kernel.org" 
	<bugzilla-daemon@bugzilla.kernel.org>
In-Reply-To: <20090908160523.715a7412@jbarnes-g45>
References: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera>
	 <Vm51Upp4EV.A.r-D.mgBpKB@chimera>	<1252427375.14735.130.camel@rc-desk>
	 <alpine.LFD.2.01.0909080943030.7458@localhost.localdomain>
	 <1252431375.14735.139.camel@rc-desk>
	 <alpine.LFD.2.01.0909081039300.7458@localhost.localdomain>
	 <20090908112014.002a35af@jbarnes-g45>
	 <alpine.LFD.2.01.0909081219130.7458@localhost.localdomain>
	 <20090908123151.1f2b18fe@jbarnes-g45>
	 <alpine.LFD.2.01.0909081502510.7458@localhost.localdomain>
	 <20090908160523.715a7412@jbarnes-g45>
Content-Type: text/plain
Date: Tue, 08 Sep 2009 16:56:22 -0700
Message-Id: <1252454182.30150.68.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 16:05 -0700, Jesse Barnes wrote:
> Any chance you could
> give it a try Reinette?

This patch also solves the issue for me. 

Tested-by: Reinette Chatre <reinette.chatre@intel.com>

Thank you very much

Reinette


