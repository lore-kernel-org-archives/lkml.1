Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbYDRIc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbYDRIc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 04:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbYDRIcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 04:32:50 -0400
Received: from nn7.de ([85.214.94.156]:56720 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbYDRIcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 04:32:50 -0400
Subject: Re: [Suspend-devel] 2.6.25-rc6 regression - hang on resume
	[Bug	10319]
From: Soeren Sonnenburg <kernel@nn7.de>
To: Romano Giannetti <romanol@upcomillas.es>
Cc: Stefan Seyfried <seife@suse.de>, "Rafael J\. Wysocki" <rjw@sisk.pl>,
       suspend-devel@lists.sourceforge.net,
       Jesse Barnes <jesse.barnes@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org
In-Reply-To: <1208504040.29641.1.camel@localhost>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
	 <pdYe6zNQVl.A.fp.nEW9HB@albercik> <1207290689.4511.1.camel@localhost>
	 <1207552602.26185.13.camel@pern>  <480794D4.9020503@suse.de>
	 <1208504040.29641.1.camel@localhost>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 18 Apr 2008 10:32:42 +0200
Message-Id: <1208507562.17078.41.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-18 at 09:34 +0200, Romano Giannetti wrote:
> 
> On Thu, 2008-04-17 at 20:20 +0200, Stefan Seyfried wrote:
> 
> > can you try if this patch to libx86 (make sure it gets installed and used...)
> > fixes the problem?
> > 
> > Index: libx86-0.99/x86-common.c
> 
> Sorry to be a bit though, but _what_ I'm supposed to patch? It's in
> s2ram sources? Thanks!

Patch the sources of libx86... (s2ram makes use of that lib to do the
POSTing)

Soeren
