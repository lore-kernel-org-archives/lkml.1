Return-Path: <linux-kernel-owner+w=401wt.eu-S1757481AbZCQNso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481AbZCQNso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 09:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbZCQNsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 09:48:18 -0400
Received: from mx1.suse.de ([195.135.220.2]:35375 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691AbZCQNsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 09:48:16 -0400
Date: Tue, 17 Mar 2009 14:17:57 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Hannes Eder <hannes@hanneseder.net>, trivial@kernel.org,
       xen-devel@lists.xensource.com, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>,
       virtualization@lists.osdl.org
Subject: Re: [PATCH v2 03/15] NULL noise: arch/x86/xen/smp.c
In-Reply-To: <49B032E1.50303@goop.org>
Message-ID: <alpine.LNX.2.00.0903171417300.11733@jikos.suse.cz>
References: <20090305190954.30062.44759.stgit@f10box.hanneseder.net> <20090305191350.30062.68789.stgit@f10box.hanneseder.net> <49B032E1.50303@goop.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Mar 2009, Jeremy Fitzhardinge wrote:

> Hannes Eder wrote:
> > Fix this sparse warnings:
> >   arch/x86/xen/smp.c:316:52: warning: Using plain integer as NULL pointer
> >   arch/x86/xen/smp.c:421:60: warning: Using plain integer as NULL pointer
> > 
> > Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> >   
> Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Noone seems to have picked this so far, so I have applied it to trivial 
tree. Thanks,

-- 
Jiri Kosina
