Return-Path: <linux-kernel-owner+w=401wt.eu-S932465AbYBMV4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465AbYBMV4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:56:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763738AbYBMVcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:32:50 -0500
Received: from waste.org ([66.93.16.53]:36842 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765573AbYBMVcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:32:48 -0500
Subject: Re: [2.6 patch] make swap_pte_to_pagemap_entry() static
From: Matt Mackall <mpm@selenic.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080213213027.GE3383@cs181133002.pp.htv.fi>
References: <20080213213027.GE3383@cs181133002.pp.htv.fi>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 15:32:08 -0600
Message-Id: <1202938328.12383.139.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-13 at 23:30 +0200, Adrian Bunk wrote:
> This patch makes the needlessly global swap_pte_to_pagemap_entry() 
> static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Thanks.

Signed-off-by: Matt Mackall <mpm@selenic.com>

-- 
Mathematics is the supreme nostalgia of our time.

