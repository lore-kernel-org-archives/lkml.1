Return-Path: <linux-kernel-owner+w=401wt.eu-S1752550AbYLSFCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbYLSFCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 00:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbYLSFCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 00:02:07 -0500
Received: from ozlabs.org ([203.10.76.45]:49044 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbYLSFCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 00:02:07 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18763.10937.847276.371262@drongo.ozlabs.ibm.com>
Date: Fri, 19 Dec 2008 16:01:45 +1100
From: Paul Mackerras <paulus@samba.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Milton Miller <miltonm@bga.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 0/5] powerpc: ftrace updates to previous patch series
In-Reply-To: <alpine.DEB.1.10.0812011315020.7645@gandalf.stny.rr.com>
References: <20081126215821.263324391@goodmis.org>
	<alpine.DEB.1.10.0811261749310.1501@gandalf.stny.rr.com>
	<20081128131014.GC26793@elte.hu>
	<alpine.DEB.1.10.0812011315020.7645@gandalf.stny.rr.com>
X-Mailer: VM 8.0.11 under Emacs 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt writes:

> Sorry, I rebased to edit the change log where I mispelled Paul's name.

So, what commits should I be pulling into powerpc.git, or what patches
should I be committing, for dynamic ftrace on powerpc?

Paul.
