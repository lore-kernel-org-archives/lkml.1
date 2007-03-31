Return-Path: <linux-kernel-owner+w=401wt.eu-S1752306AbXCaUAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbXCaUAV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 16:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbXCaUAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 16:00:21 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:57073 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752306AbXCaUAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 16:00:20 -0400
Date: Sat, 31 Mar 2007 13:00:19 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mpm@selenic.com
Subject: Re: [SLUB 2/2] i386 arch page size slab fixes
In-Reply-To: <20070331125536.a984e5ce.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703311300010.1976@schroedinger.engr.sgi.com>
References: <20070331193056.1800.68058.sendpatchset@schroedinger.engr.sgi.com>
 <20070331193107.1800.28259.sendpatchset@schroedinger.engr.sgi.com>
 <20070331125536.a984e5ce.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Mar 2007, Andrew Morton wrote:

> Can we disable SLUB on i386 in Kconfig until it gets sorted out?

Yes just do not apply this patch. The first one disables SLUB on i386.

