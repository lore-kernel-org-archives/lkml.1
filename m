Return-Path: <linux-kernel-owner+w=401wt.eu-S1752568AbZIHWhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbZIHWhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 18:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbZIHWhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 18:37:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:30529 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819AbZIHWhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 18:37:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,354,1249282800"; 
   d="scan'208";a="548855542"
Subject: Re: [Bug #13819] system freeze when switching to console
From: reinette chatre <reinette.chatre@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, "Ma, Ling" <ling.ma@intel.com>,
       "bugzilla-daemon@bugzilla.kernel.org" 
	<bugzilla-daemon@bugzilla.kernel.org>
In-Reply-To: <alpine.LFD.2.01.0909081039300.7458@localhost.localdomain>
References: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera>
	 <Vm51Upp4EV.A.r-D.mgBpKB@chimera> <1252427375.14735.130.camel@rc-desk>
	 <alpine.LFD.2.01.0909080943030.7458@localhost.localdomain>
	 <1252431375.14735.139.camel@rc-desk>
	 <alpine.LFD.2.01.0909081039300.7458@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 08 Sep 2009 15:37:41 -0700
Message-Id: <1252449461.30150.61.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 11:06 -0700, Linus Torvalds wrote:
> so this is TOTALLY UNTESTED!

I understand that the discussion is still going on whether this is the
right thing to do. Even so, I thought you may like to know that with
this patch I can again switch to console, back again, hibernate, and
shut down .. all without crashing my system.

Tested-by: Reinette Chatre <reinette.chatre@intel.com>

Thank you very much!

Reinette


