Return-Path: <linux-kernel-owner+w=401wt.eu-S1756125AbZCRK3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbZCRK3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 06:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbZCRK3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 06:29:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:50547 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849AbZCRK3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 06:29:36 -0400
Date: Wed, 18 Mar 2009 11:28:26 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "trivial@kernel.org" <trivial@kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       Hannes Eder <hannes@hanneseder.net>
Subject: Re: [PATCH v2 03/15] NULL noise: arch/x86/xen/smp.c
In-Reply-To: <49C04001.4010405@goop.org>
Message-ID: <alpine.LNX.2.00.0903181127370.31087@jikos.suse.cz>
References: <20090305190954.30062.44759.stgit@f10box.hanneseder.net> <20090305191350.30062.68789.stgit@f10box.hanneseder.net> <49B032E1.50303@goop.org> <alpine.LNX.2.00.0903171417300.11733@jikos.suse.cz> <49C04001.4010405@goop.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Mar 2009, Jeremy Fitzhardinge wrote:

> > Noone seems to have picked this so far, so I have applied it to trivial
> > tree. Thanks,
> I've got it queued up, but I'm sure we'll be able to resolve any conflicts if
> it goes via both paths...

No problem, I have dropped it from trivial tree, thanks for letting me 
know.

-- 
Jiri Kosina
SUSE Labs
