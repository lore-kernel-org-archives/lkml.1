Return-Path: <linux-kernel-owner+w=401wt.eu-S935608AbYD1Rth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935608AbYD1Rth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933677AbYD1Rt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:49:28 -0400
Received: from sous-sol.org ([216.99.217.87]:44106 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765875AbYD1Rt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:49:28 -0400
Date: Mon, 28 Apr 2008 10:48:57 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>, chrisw@sous-sol.org,
       xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: drivers/xen/grant-table.c:gnttab_suspend() is unused
Message-ID: <20080428174857.GG18358@sequoia.sous-sol.org>
References: <20080428153900.GI2813@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428153900.GI2813@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Adrian Bunk (bunk@kernel.org) wrote:
> drivers/xen/grant-table.c:gnttab_suspend() is unused, and I have the gut 
> feeling it should have been used.

Right, it should get used when suspending a guest supported.
