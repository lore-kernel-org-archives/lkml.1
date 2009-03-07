Return-Path: <linux-kernel-owner+w=401wt.eu-S1756938AbZCGWQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938AbZCGWQu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 17:16:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756360AbZCGWQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 17:16:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60638 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756255AbZCGWQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 17:16:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #12395] 2.6.28-rc9: oprofile regression
Date: Sat, 7 Mar 2009 23:16:48 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc7-tst; KDE/4.2.0; x86_64; ; )
Cc: Robert Richter <robert.richter@amd.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>, Tim Blechmann <tim@klingt.org>
References: <HFSEX4uppGO.A.JSG.2yzoJB@chimera> <20090303204504.GA20038@elte.hu> <20090304175828.GA1172@elte.hu>
In-Reply-To: <20090304175828.GA1172@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903072316.49455.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 March 2009, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > 
> > > On Tuesday 03 March 2009, Robert Richter wrote:
> > > > Fix upstream in tip/x86/urgent:
> > > > 
> > > > 780eef9492b16a1543a3b2ae9f9526a735fc9856
> > > 
> > > URL, please?
> > 
> > The fix is not yet in Linus's tree - the commit is below.
> 
> The fix is upstream now, included in .29-rc7.

Thanks, closed.

Rafael
