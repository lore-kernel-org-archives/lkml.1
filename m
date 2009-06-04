Return-Path: <linux-kernel-owner+w=401wt.eu-S1752079AbZFDR4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbZFDR4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 13:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbZFDR4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 13:56:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57144 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718AbZFDR4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 13:56:10 -0400
Date: Thu, 4 Jun 2009 13:55:36 -0400
From: Dave Jones <davej@redhat.com>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harald Welte <HaraldWelte@viatech.com>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
Message-ID: <20090604175536.GA4939@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Michael S. Zick" <lkml@morethan.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Duane Griffin <duaneg@dghda.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Harald Welte <HaraldWelte@viatech.com>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <alpine.LFD.2.01.0906040948480.4880@localhost.localdomain> <alpine.LFD.2.01.0906041004000.4880@localhost.localdomain> <200906041227.10529.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906041227.10529.lkml@morethan.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 12:27:07PM -0500, Michael S. Zick wrote:
 
 > > Features like that easily put a huge stress on power regulators etc, if 
 > > they result in sudden changes in current draw.  Underspecced capacitors 
 > > etc can cause CPU "brown-outs", which in turn can easily cause total 
 > > failure. 
 > 
 > There is also a possible thermal issue with these machines - -
 > I doubt that VIA runs their qualification testing in bake ovens;
 > which is what NetBook cases amount too.  ;)

FWIW, they do, I've toured their facility and seen those ovens ;)
I forget just how high they bake them at, but it was something ridiculous
that even netbooks won't come close to.
 
	Dave
