Return-Path: <linux-kernel-owner+w=401wt.eu-S1761211AbXKTVid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761211AbXKTVid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:38:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761628AbXKTViP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:38:15 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46017 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761305AbXKTViO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:38:14 -0500
Date: Tue, 20 Nov 2007 13:38:12 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: mel@csn.ul.ie, Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, rientjes@google.com, nacc@us.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 6/6] Use one zonelist that is filtered by nodemask
In-Reply-To: <20071120133325.21fc819e.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0711201337470.27539@schroedinger.engr.sgi.com>
References: <20071109143226.23540.12907.sendpatchset@skynet.skynet.ie>
 <20071109143426.23540.44459.sendpatchset@skynet.skynet.ie>
 <Pine.LNX.4.64.0711090741120.13932@schroedinger.engr.sgi.com>
 <20071120141953.GB32313@csn.ul.ie> <Pine.LNX.4.64.0711201217430.26419@schroedinger.engr.sgi.com>
 <20071120133325.21fc819e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007, Andrew Morton wrote:

> uhm, maybe.  It's getting toward the time when we should try to get -mm
> vaguely compiling and booting on some machines, which means stopping
> merging new stuff.  I left that too late in the 2.6.23 cycle.

Huh? mm1 works fine here.

