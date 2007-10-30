Return-Path: <linux-kernel-owner+w=401wt.eu-S1758785AbXJ3U0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785AbXJ3U0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 16:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbXJ3U03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 16:26:29 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42351 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753287AbXJ3U02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 16:26:28 -0400
Date: Tue, 30 Oct 2007 13:26:26 -0700
From: Paul Jackson <pj@sgi.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: ak@suse.de, rientjes@google.com, clameter@sgi.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Message-Id: <20071030132626.95057ea4.pj@sgi.com>
In-Reply-To: <1193775634.5039.83.camel@localhost>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	<1193674988.5035.93.camel@localhost>
	<20071029123558.fb077ca9.pj@sgi.com>
	<200710292208.30033.ak@suse.de>
	<20071030124751.0a2d50b2.pj@sgi.com>
	<1193775634.5039.83.camel@localhost>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lee wrote:
> Paul:  Andi has a regression test in the numactl source package.

Good - thanks.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
