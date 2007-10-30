Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbXJ3UVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbXJ3UVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 16:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbXJ3UU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 16:20:56 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:37463 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933AbXJ3UUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 16:20:54 -0400
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Paul Jackson <pj@sgi.com>
Cc: Andi Kleen <ak@suse.de>, rientjes@google.com, clameter@sgi.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20071030124751.0a2d50b2.pj@sgi.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	 <1193674988.5035.93.camel@localhost> <20071029123558.fb077ca9.pj@sgi.com>
	 <200710292208.30033.ak@suse.de>  <20071030124751.0a2d50b2.pj@sgi.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Tue, 30 Oct 2007 16:20:34 -0400
Message-Id: <1193775634.5039.83.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-30 at 12:47 -0700, Paul Jackson wrote:
> Andi, Christoph, or whomever:
> 
>   Are there any good regression tests of mempolicy functionality?

Paul:  Andi has a regression test in the numactl source package.

Try:
	http://freshmeat.net/redir/numactl/62210/url_tgz/numactl-1.0.2.tar.gz

Lee

