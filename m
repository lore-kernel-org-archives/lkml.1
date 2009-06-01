Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbZFAUVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbZFAUVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 16:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbZFAUVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 16:21:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56022 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991AbZFAUVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 16:21:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alex Samad <alex@samad.com.au>
Subject: Re: [Bug #13375] Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
Date: Mon, 1 Jun 2009 22:21:38 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Chinner <david@fromorbit.com>
References: <THxQaUP0K2D.A.QkF.UVbIKB@chimera> <PkPeJtNB3KO.A._pF.ZVbIKB@chimera> <20090530231018.GA29992@samad.com.au>
In-Reply-To: <20090530231018.GA29992@samad.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906012221.38854.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 31 May 2009, Alex Samad wrote:
> Hi
> 
> as far as I know it is still a problem

Thanks for the update.

Best,
Rafael

 
> On Sat, May 30, 2009 at 09:55:40PM +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.28 and 2.6.29.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13375
> > Subject		: Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
> > Submitter	: Alex Samad <alex@samad.com.au>
> > Date		: 2009-05-20 0:37 (11 days old)
> > References	: http://marc.info/?l=linux-kernel&m=124278675503699&w=4
