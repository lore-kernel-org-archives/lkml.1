Return-Path: <linux-kernel-owner+w=401wt.eu-S932112AbXGUU73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbXGUU73 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 16:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758358AbXGUU7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 16:59:17 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:35658 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757238AbXGUU7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 16:59:16 -0400
X-Greylist: delayed 1800 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Jul 2007 16:59:15 EDT
Subject: Re: [PATCH 1/3] readahead: drop behind
From: Eric St-Laurent <ericstl34@sympatico.ca>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>, riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Tim Pepper <lnxninja@us.ibm.com>,
       Chris Snook <csnook@redhat.com>
In-Reply-To: <1185050276.5652.23.camel@lappy>
References: <20070721210005.000228000@chello.nl>
	 <20070721210051.975382000@chello.nl>  <1185049747.27915.8.camel@perkele>
	 <1185050276.5652.23.camel@lappy>
Content-Type: text/plain
Date: Sat, 21 Jul 2007 16:59:11 -0400
Message-Id: <1185051551.28982.4.camel@perkele>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> They are against git of a few hours ago and the latest readahead patches
> from Wu (which don't apply cleanly either, but the rejects are trivial).
> 
> > It would be useful to have a temporary /proc tunable to enable/disable
> > the heuristic to help test the effects.
> 
> Right, I had such a patch somewhere,.. won't apply cleanly but should be
> obvious..

Thanks, I will merge theses and report back with some results.

After copying large files, I find my system sluggish. I hope your
changes will help.

- Eric


