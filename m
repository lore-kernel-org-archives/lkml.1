Return-Path: <linux-kernel-owner+w=401wt.eu-S1755961AbZBJUDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbZBJUDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 15:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbZBJUDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 15:03:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42233 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331AbZBJUDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 15:03:07 -0500
Date: Tue, 10 Feb 2009 15:00:07 -0500
From: Chuck Ebbert <cebbert@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kyle McMartin <kyle@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12666] Build failure with latest -git: btrfs on ppc64
Message-ID: <20090210150007.38bae23d@dhcp-100-2-144.bos.redhat.com>
In-Reply-To: <200902082308.14366.rjw@sisk.pl>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>
	<sWhNs83kKPE.A.x-D.N20jJB@chimera>
	<20090208215321.GE11398@bombadil.infradead.org>
	<200902082308.14366.rjw@sisk.pl>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Feb 2009 23:08:13 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Sunday 08 February 2009, Kyle McMartin wrote:
> > On Sun, Feb 08, 2009 at 08:21:49PM +0100, Rafael J. Wysocki wrote:
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12666
> > > Subject		: Build failure with latest -git: btrfs on ppc64
> > > Submitter	: Chuck Ebbert <cebbert@redhat.com>
> > > Date		: 2009-02-07 20:50 (2 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=123404002114219&w=4
> > > 
> > 
> > Just fyi, patch here:
> > Subject: x86: spinlocks: define dummy __raw_spin_is_contended                   
> > Date: Sun, 8 Feb 2009 13:03:41 -0500                                            
> > Message-ID: <20090208180341.GC11398@bombadil.infradead.org>    
> 

Patch was merged, commit a5ef7ca0e2636bad0ccd07b996d775348ae2b65e
