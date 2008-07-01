Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbYGAS7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbYGAS7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 14:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbYGAS7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 14:59:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:7108 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623AbYGAS7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 14:59:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,732,1204531200"; 
   d="scan'208";a="404139269"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Intel DG965WH / Case 745-44-22 (slow bios/upgrade) [UPDATE] / Intel, status of HECI support patch for the kernel?
Date: Tue, 1 Jul 2008 11:58:45 -0700
User-Agent: KMail/1.9.9
Cc: "crmotherboard@mailbox.intel.com" <crmotherboard@mailbox.cps.intel.com>,
       "Williams, Dan J" <dan.j.williams@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
       Anas Nashif <anas.nashif@intel.com>
References: <alpine.DEB.1.10.0806300958070.13171@p34.internal.lan> <alpine.DEB.1.10.0807011442500.18141@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0807011442500.18141@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807011158.46258.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 01, 2008 11:43 am Justin Piszcz wrote:
> > This is from 2007:
> > http://softwareblogs.intel.com/2007/04/13/intel-me-interface-heci-now-ava
> >ilable/
> >
> > Their updated project page:
> > http://www.openamt.org/
> >
> > Justin.
>
> The issue regarding accessing the hard drive menu was fixed by simpling
> power cycling/rebooting the host.

And the problem hasn't come back?

> All issues are now resolved (regarding the slow speed/memory/etc)..

Hopefully there's a more recent BIOS available that doesn't need to trim the 
memory for you?

> Only other question left is the HECI support in the kernel.

I'll defer that question to Anas, he's been handling the HECI stuff.

Jesse
