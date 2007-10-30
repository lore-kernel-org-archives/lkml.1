Return-Path: <linux-kernel-owner+w=401wt.eu-S1758184AbXJ3TsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184AbXJ3TsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755680AbXJ3Tr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:47:57 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:37611 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755018AbXJ3Tr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:47:56 -0400
Date: Tue, 30 Oct 2007 12:47:51 -0700
From: Paul Jackson <pj@sgi.com>
To: Andi Kleen <ak@suse.de>
Cc: Lee.Schermerhorn@hp.com, rientjes@google.com, clameter@sgi.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Message-Id: <20071030124751.0a2d50b2.pj@sgi.com>
In-Reply-To: <200710292208.30033.ak@suse.de>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	<1193674988.5035.93.camel@localhost>
	<20071029123558.fb077ca9.pj@sgi.com>
	<200710292208.30033.ak@suse.de>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi, Christoph, or whomever:

  Are there any good regression tests of mempolicy functionality?

  This patch I'm coding is delicate enough that I probably broke
  something.  It would be nice to catch it sooner rather than later.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
