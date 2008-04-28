Return-Path: <linux-kernel-owner+w=401wt.eu-S935111AbYD1SEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935111AbYD1SEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932409AbYD1SEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:04:10 -0400
Received: from sous-sol.org ([216.99.217.87]:34391 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766005AbYD1SEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:04:09 -0400
Date: Mon, 28 Apr 2008 11:03:40 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, chrisw@sous-sol.org,
       xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] drivers/xen/balloon.c: make a function static
Message-ID: <20080428180340.GH18358@sequoia.sous-sol.org>
References: <20080428153941.GR2813@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428153941.GR2813@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Adrian Bunk (bunk@kernel.org) wrote:
> This patch makes the needlessly global balloon_set_new_target() static.

Right, this is fine.  Cruft left from merge.

> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Chris Wright <chrisw@sous-sol.org>
